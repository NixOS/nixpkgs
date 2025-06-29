wallpaperCompatHook() {
  echo "Running wallpaperCompatHook"

  local backgrounds_dir="$out/share/backgrounds"
  local wallpapers_dir="$out/share/wallpapers"

  # Default name, if there isn't already one that we can use
  local default_wallpaper_name=$(echo "$pname" | sed 's/wallpapers\?//i' | sed 's/^-//' | sed 's/-$//')
  # Detect if there is an existing directory in $backgrounds_dir that we can co-opt. If there are multiple, keep the default name.
  local existing_wallpaper_dirs=($(find "$backgrounds_dir" -mindepth 1 -maxdepth 1 -type d))
  if [[ ${#existing_wallpaper_dirs[@]} -eq 1 ]]; then
    default_wallpaper_name=$(basename "${existing_wallpaper_dirs[0]}")
  fi
  echo "wallpaperCompatHook: default_wallpaper_name=$default_wallpaper_name"

  local added_wallpapers=()

  for dir in "$backgrounds_dir"/*/; do
    local wallpaper_name=$(basename "$dir")

    for image_file in "$dir"/*; do
      local image=$(basename "$image_file")
      local image_no_ext="${image%.*}"
      local image_ext="${image##*.}"

      # Search wallpapers_dir for same image. If not found, create a wallpaper called $wallpaper_name-$image (without extension)
      if [[ ! -f "$wallpapers_dir/$wallpaper_name/contents/images/$image" ]]; then
        echo "wallpaperCompatHook: Creating wallpaper $wallpaper_name-$image"
        mkdir -p "$wallpapers_dir/$wallpaper_name-$image_no_ext/contents/images"
        ln -s "$image_file" "$wallpapers_dir/$wallpaper_name-$image_no_ext/contents/images/$(identify -format "%wx%h" "$image_file").$image_ext"
        added_wallpapers+=($(basename "$wallpapers_dir/$wallpaper_name-$image_no_ext"))
        cat >> $wallpapers_dir/$wallpaper_name-$image_no_ext/metadata.desktop <<_EOF
[Desktop Entry]
Name=$image_no_ext
X-KDE-PluginInfo-Name=$wallpaper_name-$image_no_ext
_EOF
        cat >> $wallpapers_dir/$wallpaper_name-$image_no_ext/metadata.json <<_EOF
{
  "KPlugin": {
    "Id": "$wallpaper_name-$image_no_ext",
    "Name": "$image_no_ext",
  }
}
_EOF
      fi
    done
  done

  for wallpaper_dir in "$wallpapers_dir"/*/; do
    wallpaper_name=$(basename "$wallpaper_dir")
    # If we added it ourselves, skip
    if [[ " ${added_wallpapers[@]} " =~ "$wallpaper_name" ]]; then
      echo "wallpaperCompatHook: Skipping $wallpaper_name as it was added by us"
      continue
    fi
    # Else, create a symlink to the wallpaper in backgrounds_dir
    echo "wallpaperCompatHook: Creating background $wallpaper_name with default directory $default_wallpaper_name"
    local best_image=$(find "$wallpaper_dir/contents/images" -type f -name '*.jpg' -o -name '*.png' -o -name '*.jpeg' -o -name '*.svg' -o -name '*.webp' | xargs identify -format "%w %h %i\n" | awk '{print $1/$2, $1, $2, $3}' | sort -n | tail -n 1 | cut -d' ' -f4)
    echo "wallpaperCompatHook: Best image for $wallpaper_name is $best_image with resolution $(identify -format "%wx%h" "$best_image")"
    mkdir -p "$backgrounds_dir/$default_wallpaper_name"
    ln -s "$best_image" "$backgrounds_dir/$default_wallpaper_name/$(basename "$best_image")"
    echo "wallpaperCompatHook: Created symlink $backgrounds_dir/$default_wallpaper_name/$(basename "$best_image") -> $best_image"
  done

  # Run desktoptojson on every $wallpapers_dir/*/metadata.desktop that doesn't have a corresponding .json file
  for metadata_file in "$wallpapers_dir"/*/metadata.desktop; do
    local wallpaper_name=$(basename "$(dirname "$metadata_file")")
    local json_file="$wallpapers_dir/$wallpaper_name/metadata.json"
    if [[ ! -f "$json_file" ]]; then
      echo "wallpaperCompatHook: Running desktoptojson on $metadata_file"
      desktoptojson --input "$metadata_file" --output "$json_file"
    fi
  done
}

fixupOutputHooks+=('wallpaperCompatHook')
