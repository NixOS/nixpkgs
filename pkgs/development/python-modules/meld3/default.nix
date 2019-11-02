{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "meld3";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fbyafwi0d54394hkmp65nf6vk0qm4kipf5z60pdp4244rvadz8y";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "An HTML/XML templating engine used by supervisor";
    homepage = https://github.com/supervisor/meld3;
    license = licenses.free;
  };

}
