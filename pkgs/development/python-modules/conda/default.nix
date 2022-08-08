{ lib
, buildPythonPackage
, fetchFromGitHub
, pycosat
, requests
, ruamel-yaml
, isPy3k
, enum34
, pytestCheckHook
, ruamel-yaml-conda
}:

# Note: this installs conda as a library. The application cannot be used.
# This is likely therefore NOT what you're looking for.

buildPythonPackage rec {
  pname = "conda";
  version = "4.14.0";

  src = fetchFromGitHub {
    owner = "conda";
    repo = "conda";
    rev = version;
    sha256 = "sha256-nmQP6K2eyT0t7KKKSE4hUVsxIhMoCCEpN5ktcs5I+Sk=";
  };

  postPatch = ''
    echo ${version} > conda/.version
  '';

  propagatedBuildInputs = [
    pycosat
    requests
    ruamel-yaml
    ruamel-yaml-conda
  ] ++ lib.optional (!isPy3k) enum34;

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "conda" ];

  meta = with lib; {
    description = "OS-agnostic, system-level binary package manager";
    homepage = "https://github.com/conda/conda";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };

}
