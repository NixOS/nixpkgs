{ fetchFromGitHub }:
rec {
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "openexr";
    repo = "openexr";
    rev = "v${version}";
    sha256 = "030vj2jk3n65x1wl0rmxzpl1bd5mzmld2lzn7sg92svpnghry6a8";
  };
}
