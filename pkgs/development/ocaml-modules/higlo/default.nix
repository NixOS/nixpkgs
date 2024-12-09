{ lib, buildDunePackage, fetchFromGitLab, sedlex, xtmpl }:

buildDunePackage rec {
  pname = "higlo";
  version = "0.9";

  src = fetchFromGitLab {
    domain = "framagit.org";
    owner = "zoggy";
    repo = "higlo";
    rev = version;
    hash = "sha256-SaFFzp4FCjVLdMLH6mNIv3HzJbkXJ5Ojbku258LCfLI=";
  };

  propagatedBuildInputs = [ sedlex xtmpl ];

  meta = with lib; {
    description = "OCaml library for syntax highlighting";
    inherit (src.meta) homepage;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ regnat ];
  };
}


