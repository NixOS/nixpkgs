notoConfigureHook() {
  @patchConfig@ "sources/config-$fontName.yaml"
}

notoBuildPhase() {
  export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python
  notobuilder "sources/config-$fontName.yaml"
  rm -rf fonts/*/{hinted,googlefonts,unhinted/slim-variable-ttf}
}

notoInstallPhase() {
  runHook preInstall

  runHook postInstall
}

postConfigureHooks+=(notoConfigureHook)
buildPhase=notoBuildPhase
installPhase=notoInstallPhase
dontUseNinjaInstall=true
