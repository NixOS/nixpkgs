{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "meld3";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0n4mkwlpsqnmn0dm0wm5hn9nkda0nafl0jdy5sdl5977znh59dzp";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "An HTML/XML templating engine used by supervisor";
    homepage = https://github.com/supervisor/meld3;
    license = licenses.free;
  };

}
