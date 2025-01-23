{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  mutagen,
  pytestCheckHook,
  pythonOlder,
  six,
}:

buildPythonPackage rec {
  pname = "mediafile";
  version = "0.12.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "beetbox";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5HHfG1hCIbM/QSXgB61yHNNWJTsuyAh6CQJ7SZhZuvo=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    mutagen
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mediafile" ];

  meta = with lib; {
    description = "Python interface to the metadata tags for many audio file formats";
    homepage = "https://github.com/beetbox/mediafile";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
