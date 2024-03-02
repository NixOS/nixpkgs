{ fetchFromGitHub
, ...
}:

rec {
  version = "0.9.1";
  rSrc = fetchFromGitHub {
    owner = "abathur";
    repo = "resholve";
    rev = "v${version}";
    hash = "sha256-hkLKQKhEMD1UQ9EunPmx5Tsh44q4+tYj820OXF2ueUo=";
  };
}
