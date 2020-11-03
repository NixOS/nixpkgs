{ lib
, buildPythonPackage
, fetchurl
, python
, pkg-config
, imagemagick
, autoreconfHook
, boost
, isPy3k
, pythonImportsCheckHook
}:

buildPythonPackage rec {
  pname = "pythonmagick";
  version = "0.9.16";
  format = "other";

  src = fetchurl {
    url = "mirror://imagemagick/python/releases/PythonMagick-${version}.tar.xz";
    sha256 = "137278mfb5079lns2mmw73x8dhpzgwha53dyl00mmhj2z25varpn";
  };

  postPatch = ''
    rm configure
  '';

  configureFlags = [ "--with-boost=${boost}" ];

  nativeBuildInputs = [ pkg-config autoreconfHook pythonImportsCheckHook ];
  buildInputs = [ python boost imagemagick ];

  pythonImportsCheck = [
    "PythonMagick"
  ];

  meta = with lib; {
    homepage = "http://www.imagemagick.org/script/api.php";
    license = licenses.imagemagick;
    description = "PythonMagick provides object oriented bindings for the ImageMagick Library.";
    broken = true;
  };
}
