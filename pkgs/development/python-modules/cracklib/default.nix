{ lib, buildPythonPackage, fetchPypi, cracklib }:

buildPythonPackage rec {
  pname = "cracklib";
  version = "2.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15ivsi7plmhyzgcyblqxsli42iyg0finhnf94dq3699vj10076b9";
  };

  # pypi archive doesn't contain the dictionary necessary to run tests
  doCheck = false;

  buildInputs = [ cracklib ];

  meta = {
    homepage = https://sourceforge.net/projects/cracklib/;
    description = "A CPython extension module wrapping the libcrack library";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ trizinix ];
  };
}

