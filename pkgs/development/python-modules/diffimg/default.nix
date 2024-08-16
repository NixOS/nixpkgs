{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pillow,
  unittestCheckHook,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "diffimg";
  version = "0.3.0"; # github recognized 0.1.3, there's a v0.1.5 tag and setup.py says 0.3.0
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "nicolashahn";
    repo = "diffimg";
    rev = "b82f0bb416f100f9105ccccf1995872b29302461";
    hash = "sha256-H/UQsqyfdnlESBe7yRu6nK/0dakQkAfeFaZNwjCMvdM=";
  };

  # it imports the wrong diff,
  # fix offered to upstream https://github.com/nicolashahn/diffimg/pull/6
  postPatch =
    ''
      substituteInPlace diffimg/test.py \
        --replace-warn "from diff import diff" "from diffimg.diff import diff"
    ''
    + lib.optionalString (pythonAtLeast "3.12") ''
      substituteInPlace diffimg/test.py \
        --replace-warn "3503192421617232" "3503192421617233"
    '';

  propagatedBuildInputs = [ pillow ];

  pythonImportsCheck = [ "diffimg" ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = with lib; {
    description = "Differentiate images in python - get a ratio or percentage difference, and generate a diff image";
    homepage = "https://github.com/nicolashahn/diffimg";
    license = licenses.mit;
    maintainers = with maintainers; [ evils ];
  };
}
