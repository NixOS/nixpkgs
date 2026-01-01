{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "trustymail";
<<<<<<< HEAD
  version = "1.2.1";
=======
  version = "1.2.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cisagov";
    repo = "trustymail";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-NF89Am/sG3Ruaws2SUofrbLoEiKdYpgPuXIAKjst9hk=";
=======
    hash = "sha256-EA8RomXREDAHZIuq8x+t6w7V1ErUOuuo0TUyaxIgdR8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies =
    with python3.pkgs;
    [
      dnspython
      docopt
      publicsuffixlist
      py3dns
      pyspf
      requests
    ]
    ++ publicsuffixlist.optional-dependencies.update;

  nativeCheckInputs = with python3.pkgs; [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "trustymail" ];

<<<<<<< HEAD
  meta = {
    description = "Tool to scan domains and return data based on trustworthy email best practices";
    homepage = "https://github.com/cisagov/trustymail";
    changelog = "https://github.com/cisagov/trustymail/releases/tag/${src.tag}";
    license = with lib.licenses; [ cc0 ];
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Tool to scan domains and return data based on trustworthy email best practices";
    homepage = "https://github.com/cisagov/trustymail";
    changelog = "https://github.com/cisagov/trustymail/releases/tag/${src.tag}";
    license = with licenses; [ cc0 ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "trustymail";
  };
}
