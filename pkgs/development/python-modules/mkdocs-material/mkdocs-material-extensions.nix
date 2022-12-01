{ lib, fetchFromGitHub, buildPythonPackage }:

buildPythonPackage rec {
  pname = "mkdocs-material-extensions";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "facelessuser";
    repo = pname;
    rev = version;
    sha256 = "1mvc13lz16apnli2qcqf0dvlm8mshy47jmz2vp72lja6x8jfq2p3";
  };

  doCheck = false; # Circular dependency

  pythonImportsCheck = [ "materialx" ];

  meta = with lib; {
    description = "Markdown extension resources for MkDocs Material";
    homepage = "https://github.com/facelessuser/mkdocs-material-extensions";
    license = licenses.mit;
    maintainers = with maintainers; [ dandellion ];
  };
}
