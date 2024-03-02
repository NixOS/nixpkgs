{ lib
, stdenv
, fetchFromGitea
}:

stdenv.mkDerivation rec {
  pname = "libjodycode";
  version = "3.1";

  outputs = [ "out" "man" "dev" ];

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "jbruchon";
    repo = "libjodycode";
    rev = "v${version}";
    hash = "sha256-uhWQh5YwLwYRm34nY5HvcEepqlTSDt9s3PSoD403kQM=";
  };

  env.PREFIX = placeholder "out";

  meta = with lib; {
    description = "Shared code used by several utilities written by Jody Bruchon";
    homepage = "https://github.com/jbruchon/libjodycode";
    changelog = "https://github.com/jbruchon/libjodycode/blob/${src.rev}/CHANGES.txt";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}
