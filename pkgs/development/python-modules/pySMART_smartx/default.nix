{ stdenv, buildPythonPackage, fetchPypi
}:

buildPythonPackage rec {
  pname = "pySMART.smartx";
  version = "0.3.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16chrzqz3ykpkikfdi71z1g31hm8pij5gs9p6fsxjd6r3awxj1zr";
  };

  meta = with stdenv.lib; {
    description = "Fork for pySMART, bug fix and enhance.";
    homepage    = https://github.com/smartxworks/pySMART;
    license     = licenses.gpl2;
    maintainers = [ maintainers.marenz ];
  };
}
