{ lib
, buildPythonPackage
, fetchPypi
, glibcLocales
}:

buildPythonPackage rec {
  pname = "Arpeggio";
  version = "1.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rvgwc2nxqf22fjnggswqw2i3sn1f2hhq043vhjr3af7ldfai3l2";
  };

  # Shall not be needed for next release
  LC_ALL = "en_US.UTF-8";
  buildInputs = [ glibcLocales ];

  meta = {
    description = "Packrat parser interpreter";
    license = lib.licenses.mit;
  };
}
