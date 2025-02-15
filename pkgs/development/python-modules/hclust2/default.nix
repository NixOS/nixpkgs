{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  matplotlib,
  nix-update-script,
  numpy,
  pandas,
  scipy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "hclust2";
  version = "1.0.0";

  pyproject = true;
  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "SegataLab";
    repo = "hclust2";
    tag = "version";
    hash = "sha256-xdS36Sfxg4bz5ztRbCdD3uq4Dx50E8n501ScMArjwso=";
  };

  dependencies = [
    numpy
    scipy
    pandas
    matplotlib
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/SegataLab/hclust2/releases";
    description = "Tool for plotting heat-maps with several useful options to produce high quality figures that can be used in publication";
    downloadPage = "https://pypi.org/project/hclust2/#files";
    homepage = "https://github.com/SegataLab/hclust2";
    license = lib.licenses.mit;
    mainProgram = "hclust2.py";
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
