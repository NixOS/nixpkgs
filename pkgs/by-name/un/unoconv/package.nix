{
  lib,
  stdenv,
  fetchFromGitHub,
  libreoffice-unwrapped,
  asciidoc,
  makeWrapper,
  # whether to install odt2pdf/odt2doc/... symlinks to unoconv
  installSymlinks ? true,
}:

stdenv.mkDerivation rec {
  pname = "unoconv";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "unoconv";
    repo = "unoconv";
    rev = version;
    sha256 = "1akx64686in8j8arl6vsgp2n3bv770q48pfv283c6fz6wf9p8fvr";
  };

  nativeBuildInputs = [
    asciidoc
    makeWrapper
  ];

  preBuild = ''
    makeFlags=prefix="$out"
  '';

  postInstall = ''
    sed -i "s|/usr/bin/env python.*|${libreoffice-unwrapped.python.interpreter}|" "$out/bin/unoconv"
    wrapProgram "$out/bin/unoconv" \
        --set-default UNO_PATH "${libreoffice-unwrapped}/lib/libreoffice/program/"
  ''
  + lib.optionalString installSymlinks ''
    make install-links prefix="$out"
  '';

  meta = with lib; {
    description = "Convert between any document format supported by LibreOffice/OpenOffice";
    homepage = "http://dag.wieers.com/home-made/unoconv/";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
    mainProgram = "unoconv";
  };
}
