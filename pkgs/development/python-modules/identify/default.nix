{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, editdistance-s
}:

buildPythonPackage rec {
  pname = "identify";
  version = "2.2.10";


  src = fetchFromGitHub {
    owner = "pre-commit";
    repo = pname;
    rev = "v${version}";
    sha256 = "017xcwm8m42a1v3v0fs8v3m2sga97rx9a7vk0cb2g14777f4w4si";
  };

  checkInputs = [
    editdistance-s
    pytestCheckHook
  ];

  pythonImportsCheck = [ "identify" ];

  meta = with lib; {
    description = "File identification library for Python";
    homepage = "https://github.com/chriskuehl/identify";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
