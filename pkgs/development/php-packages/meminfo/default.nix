{
  buildPecl,
  lib,
  fetchFromGitHub,
}:

buildPecl rec {
  version = "unstable-2022-03-25";
  pname = "meminfo";

  src = fetchFromGitHub {
    owner = "BitOne";
    repo = "php-meminfo";
    rev = "0ab7f5aea96c4dafce27c7e215b4907db2a2f493";
    hash = "sha256-MO+B+ZNg6OAnxkOtdA15o+G41XbsG1N1WBz7thMCjck=";
  };

  sourceRoot = "${src.name}/extension";

  meta = {
    description = "PHP extension to get insight about memory usage";
    homepage = "https://github.com/BitOne/php-meminfo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
