{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "meld3";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "57b41eebbb5a82d4a928608962616442e239ec6d611fe6f46343e765e36f0b2b";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "An HTML/XML templating engine used by supervisor";
    homepage = https://github.com/supervisor/meld3;
    license = licenses.free;
  };

}
