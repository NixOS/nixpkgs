{
  lib,
  python3,
  fetchFromGitHub,
}:

let
  version = "3.0b1";
  src = fetchFromGitHub {
    owner = "Shoobx";
    repo = "xmldiff";
    rev = version;
    hash = "sha256-Kaogc76VC0XnWkc883IMK37v4SO76dnnqy+FQ1vymVw=";
  };
in
python3.pkgs.buildPythonApplication {
  pname = "xmldiff";
  inherit version src;
  pyproject = true;

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    lxml
    setuptools # pkg_resources is imported during runtime
  ];

  meta = {
    homepage = "https://xmldiff.readthedocs.io/en/stable/";
    description = "Library and command line utility for diffing xml";
    longDescription = ''
      xmldiff is a library and a command-line utility for making diffs out of
      XML. This may seem like something that doesn't need a dedicated utility,
      but change detection in hierarchical data is very different from change
      detection in flat data. XML type formats are also not only used for
      computer readable data, it is also often used as a format for hierarchical
      data that can be rendered into human readable formats. A traditional diff
      on such a format would tell you line by line the differences, but this
      would not be readable by a human. xmldiff provides tools to make human
      readable diffs in those situations.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anpryl ];
  };
}
