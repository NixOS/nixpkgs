{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "txt2tags";
  version = "3.9";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "txt2tags";
    repo = "txt2tags";
    rev = "refs/tags/${version}";
    hash = "sha256-PwPGJJg79ny13gEb1WmgIVHcXQppI/j5mhIyOZjR19k=";
  };

  postPatch = ''
    substituteInPlace test/lib.py \
      --replace 'TXT2TAGS = os.path.join(TEST_DIR, "..", "txt2tags.py")' \
                'TXT2TAGS = "${placeholder "out"}/bin/txt2tags"' \
      --replace "[PYTHON] + TXT2TAGS" "TXT2TAGS"
  '';

  checkPhase = ''
    ${python3.interpreter} test/run.py
  '';

  meta = {
    changelog = "https://github.com/txt2tags/txt2tags/blob/${src.rev}/CHANGELOG.md";
    description = "Convert between markup languages";
    mainProgram = "txt2tags";
    homepage = "https://txt2tags.org/";
    license  = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ dotlambda kovirobi ];
  };
}
