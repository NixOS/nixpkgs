{ stdenv, buildPythonPackage, fetchFromGitHub, pythonOlder
, pytest, pytestrunner, pyyaml, six, pathlib2, isPy27 }:

buildPythonPackage rec {
  pname = "omegaconf";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "omry";
    repo = pname;
    rev = version;
    sha256 = "1vpcdjlq54pm8xmkv2hqm2n1ysvz2a9iqgf55x0w6slrb4595cwb";
  };

  checkInputs = [ pytest ];
  buildInputs = [ pytestrunner ];
  propagatedBuildInputs = [ pyyaml six ] ++ stdenv.lib.optional isPy27 pathlib2;

  meta = with stdenv.lib; {
    description = "A framework for configuring complex applications";
    homepage = "https://github.com/omry/omegaconf";
    license = licenses.free;  # prior bsd license (1988)
    maintainers = with maintainers; [ bcdarwin ];
  };
}
