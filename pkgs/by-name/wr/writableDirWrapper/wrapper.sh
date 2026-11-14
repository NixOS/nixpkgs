# makeWritableDirWrapper EXECUTABLE OUT_PATH DIR ARGS

# ARGS:
# --dont-track-version               : don't relink when version mismatches
#
# --post-link-run      COMMAND       : run command after linking
#
# --link               SRC DST       : link SRC to DST

makeWritableDirWrapper() {
  local original="$1"; shift
  local wrapper="$1"; shift
  local dir="$1"; shift
  local postLinkRun dontTrackVersion
  local -A links

  local makeWrapperParams=("$original" "$wrapper")
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      --post-link-run)
        postLinkRun="$2"; shift
        ;;
      --dont-track-version)
        dontTrackVersion=true
        ;;
      --link)
        src="$2"; shift
        dst="$2"; shift
        links["$src"]="$dst"
        ;;
      *) makeWrapperParams+=("$1") ;;
    esac
    shift
  done

  local fragment=$(mktemp)

  local unlinkCommands=()
  local linkCommands=()
  for src in "${!links[@]}"; do
    dst=${links[$src]}
    unlinkCommands+=("[[ -d \"$dir/$dst\" ]] && find \"$dir/$dst\" -type l -lname '$src' -delete;")
    linkCommands+=(
      "mkdir -p './$dst';"
      "@lndir@ -silent '$src' './$dst';"
    )
  done


  {
    cat <<EOF
unlink() {
  echo 'Removing existing file links'
  ${unlinkCommands[@]}
}

link() {
  echo 'Linking files'
  mkdir -p "$dir"
EOF

    if [[ -z "$dontTrackVersion" ]]; then
      echo "  echo '$version' > \"$dir/.$pname.version\""
    fi

    # In case that postLink needs to remove some links to avoid conflict,
    # we first link everything into a temporary directory then move over
    cat <<EOF
  (
    cd \$(mktemp -d)
    ${linkCommands[@]}
    $postLinkRun
    cp -a ./. -t "$dir"
  )
}

relink() {
  [[ -d "$dir" ]] && unlink
  link
}

declare manuallyRelink
for arg in "\$@"; do
  case "\$arg" in
    --relink-files) manuallyRelink=true ;;
    *) args+=("\$arg") ;; # Passthrough all other args
  esac
done
set -- "\${args[@]}"

if [[ -n "\$manuallyRelink" ]]; then
  echo "Manually relinking files"; relink
elif [[ ! -d "$dir" ]]; then
  echo "Directory $dir not found. Linking files..."; relink
EOF

    if [[ -z "$dontTrackVersion" ]]; then
      cat <<EOF
elif [[ ! -e "$dir/.$name.version" ]]; then
  echo "Version file not found. Relinking files just to be safe..."; relink
elif [[ '$version' != "\$(<"$dir/.$pname.version")" ]]; then
  echo "Current version is not the same as the newest version ($version). Relinking files"; relink
EOF
    fi

    echo "fi"
  } >> "$fragment"

  makeWrapper "${makeWrapperParams[@]}"

  # Inject after the shebang
  sed -i "1r $fragment" "$wrapper"
}

# Syntax: wrapProgramInWritableDir <PROGRAM> <DIRECTORY> <MAKE-WRAPPER FLAGS...>
wrapProgramInWritableDir() {
    local prog="$1"
    local dir="$2"
    local hidden

    assertExecutable "$prog"

    hidden="$(dirname "$prog")/.$(basename "$prog")"-wrapped
    while [ -e "$hidden" ]; do
      hidden="${hidden}_"
    done
    mv "$prog" "$hidden"
    makeWritableDirWrapper "$hidden" "$prog" "$dir" --inherit-argv0 "${@:3}"
}
