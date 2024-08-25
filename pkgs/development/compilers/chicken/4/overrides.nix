{
  setup-helper = {
    preBuild = ''
      substituteInPlace setup-helper.setup \
        --replace-fail "(chicken-home)" \"$out/share/\"

        cat setup-helper.setup
    '';
  };
}
