{ stdenv, buildPythonPackage, fetchPypi
, pyparsing, six, pytest, pretend }:

buildPythonPackage rec {
  pname = "packaging";
  version = "20.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e665345f9eef0c621aa0bf2f8d78cf6d21904eef16a93f020240b704a57f1334";
  };

  propagatedBuildInputs = [ pyparsing six ];

  checkInputs = [ pytest pretend ];

  checkPhase = ''
    py.test tests
  '';

  # Prevent circular dependency
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Core utilities for Python packages";
    homepage = https://github.com/pypa/packaging;
    license = [ licenses.bsd2 licenses.asl20 ];
    maintainers = with maintainers; [ bennofs ];
  };
}
