{ lib, buildPythonPackage, fetchFromGitHub, pythonAtLeast }:

buildPythonPackage rec {
  pname = "assay";
  version = "unstable-2022-01-19";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "brandon-rhodes";
    repo = pname;
    rev = "bb62d1f7d51d798b05a88045fff3a2ff92c299c3";
    hash = "sha256-FuAD74mFJ9F9AMgB3vPmODAlZKgPR7FQ4yn7HEBS5Rw=";
  };

  pythonImportsCheck = [ "assay" ];

  meta = with lib; {
    homepage = "https://github.com/brandon-rhodes/assay";
    description = "Attempt to write a Python testing framework I can actually stand";
    license = licenses.mit;
    maintainers = with maintainers; [ zane ];
    broken = pythonAtLeast "3.11";
  };
}
