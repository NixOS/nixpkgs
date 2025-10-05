{
  fetchgit,
  gitUpdater,
  glib,
  gobject-introspection,
  gtk3,
  lib,
  python3Packages,
  sound-theme-freedesktop,
  stdenv,
  wrapGAppsHook4,
}:
python3Packages.buildPythonApplication rec {
  pname = "timekpr";
  version = "0.5.8";

  src = fetchgit {
    url = "https://git.launchpad.net/timekpr-next";
    tag = "v${version}";
    hash = "sha256-Y0jAKl553HjoP59wJnKBKq4Ogko1cs8uazW2dy7AlBo=";
  };

  buildInputs = [
    glib
    gtk3
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook4
  ];

  pyproject = true;

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    dbus-python
    pygobject3
    psutil
  ];

  # Generate setup.py because the upstream repository does not include it
  SETUP_PY = ''
    from setuptools import setup, find_namespace_packages

    package_dir={"timekpr": "."}
    setup(
      name="timekpr-next",
      version="${version}",
      package_dir=package_dir,
      packages=[
        f"{package_prefix}.{package_suffix}"
        for package_prefix, where in package_dir.items()
        for package_suffix in find_namespace_packages(where=where)
      ],
      install_requires=[
        ${lib.concatMapStringsSep ", " (dependency: "'${dependency.pname}'") dependencies}
      ],
    )
  '';

  postPatch = ''
    shopt -s globstar extglob nullglob

    substituteInPlace bin/* **/*.py resource/server/systemd/timekpr.service \
      --replace-quiet /usr/lib/python3/dist-packages "$out"/${lib.escapeShellArg python3Packages.python.sitePackages}

    substituteInPlace **/*.desktop **/*.policy **/*.service \
      --replace-fail /usr/bin/timekpr "$out"/bin/timekpr

    substituteInPlace common/constants/constants.py \
      --replace-fail /usr/share/sounds/freedesktop ${lib.escapeShellArg sound-theme-freedesktop}/share/sounds/freedesktop \
      --replace-fail /usr/share/timekpr "$out"/share/timekpr \
      --replace-fail /usr/share/locale "$out"/share/locale

    substituteInPlace resource/server/timekpr.conf \
      --replace-fail /usr/share/timekpr "$out"/share/timekpr \

    # The original file name `timekpra` is renamed to `..timekpra-wrapped-wrapped` because `makeCWrapper` was used multiple times.
    substituteInPlace client/admin/adminprocessor.py \
      --replace-fail '"/timekpra" in ' '"/..timekpra-wrapped-wrapped" in '

    printf %s "$SETUP_PY" > setup.py
  '';

  # We need to manually inject $PYTHONPATH here, because `buildPythonApplication` does not recognize timekpr's executables as Python scripts, and therefore it does not automatically inject $PYTHONPATH into them.
  postFixup = ''
    for executable in $out/bin/*
    do
      wrapProgram "$executable" --prefix PYTHONPATH : "$PYTHONPATH"
    done
  '';

  preInstall = ''
    while IFS= read -r line
    do
      # Trim leading/trailing whitespace
      line=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

      # Skip empty lines and comments
      if [[ -z "$line" || "$line" =~ ^# ]]; then
          continue
      fi

      # Separate source and destination
      # This assumes the destination is the last field and source path doesn't contain problematic spaces
      # More robust parsing might be needed if source paths have spaces.
      source_path=$(echo "$line" | awk '{ $NF=""; print $0 }' | sed 's/[[:space:]]*$//')
      dest_path=$(echo "$line" | awk '{ print $NF }')

      # Check destination path prefix and map to $out/*
      case "$dest_path" in
        usr/share/*)
          # Remove "usr/" prefix and prepend "$out/"
          install -D --mode=444 "$source_path" --target-directory="$out/''${dest_path#usr/}"
          ;;
        usr/bin/*)
          # Remove "usr/" prefix and prepend "$out/"
          install -D --mode=555 "$source_path" --target-directory="$out/''${dest_path#usr/}"
          ;;
        etc/*|lib/*|var/*)
          # Prepend "$out/"
          install -D --mode=444 "$source_path" --target-directory="$out/$dest_path"
          ;;
        usr/lib/python3/dist-packages/*)
          # Skip this line if the destination is a Python module
          # because it will be handled by the Python build process
          continue
          ;;
        *)
          echo "Error: Unknown destination prefix: '$dest_path'" >&2
          exit 1
          ;;
      esac
    done < debian/install
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Manages and restricts user screen time by enforcing time limits";
    homepage = "https://mjasnik.gitlab.io/timekpr-next/";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.atry ];
    platforms = lib.platforms.linux;
  };
}
