{ qtModule
, qtbase
, libglvnd, libxkbcommon, vulkan-headers # TODO should be inherited from qtbase
}:

qtModule {
  pname = "qtshadertools";
  qtInputs = [ qtbase ];
  buildInputs = [ libglvnd libxkbcommon vulkan-headers ];
  outputs = [ "out" "dev" ];
  # quickfix so cmake can find bin/qsb
  postFixup = ''
    ln -v -s $out/bin $dev/
  '';
}
