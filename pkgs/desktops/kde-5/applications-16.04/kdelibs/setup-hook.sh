addQt4Plugins() {
  if [[ -d "$1/lib/qt4/plugins" ]]; then
      propagatedUserEnvPkgs+=" $1"
  fi

  if [[ -d "$1/lib/kde4/plugins" ]]; then
      propagatedUserEnvPkgs+=" $1"
  fi
}
envHooks+=(addQt4Plugins)
