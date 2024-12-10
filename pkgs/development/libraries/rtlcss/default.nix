{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  ...
}:

buildNpmPackage rec {
  pname = "rtlcss";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "MohammadYounes";
    repo = "rtlcss";
    rev = "v${version}";
    hash = "sha256-KdAf7jzt8o/YEzT/bLCXj546HX0oC90kr44u3p3qv/k=";
  };

  npmDepsHash = "sha256-ghVgvw55w7T9WxokYtlFSgCfGvcOxFzm2wQIFi+6uBY=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Framework for converting Left-To-Right (LTR) Cascading Style Sheets(CSS) to Right-To-Left (RTL)";
    mainProgram = "rtlcss";
    homepage = "https://rtlcss.com";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
