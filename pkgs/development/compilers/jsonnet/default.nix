{ stdenv, lib, jekyll, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "jsonnet";
  version = "0.19.1";
  outputs = ["out" "doc"];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "google";
    repo = "jsonnet";
    sha256 = "sha256-q1MNdbyrx4vvN5woe0o90pPqaNtsZjI5RQ7KJt7rOpU=";
  };

  nativeBuildInputs = [ jekyll ];

  enableParallelBuilding = true;

  makeFlags = [
    "jsonnet"
    "jsonnetfmt"
    "libjsonnet.so"
  ];

  # Upstream writes documentation in html, not in markdown/rst, so no
  # other output formats, sorry.
  preBuild = ''
    jekyll build --source ./doc --destination ./html
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib $out/include $out/share/doc/jsonnet
    cp jsonnet $out/bin/
    cp jsonnetfmt $out/bin/
    cp libjsonnet*.so $out/lib/
    cp -a include/*.h $out/include/
    cp -r ./html $out/share/doc/jsonnet
  '';

  meta = {
    description = "Purely-functional configuration language that helps you define JSON data";
    maintainers = with lib.maintainers; [ benley copumpkin ];
    license = lib.licenses.asl20;
    homepage = "https://github.com/google/jsonnet";
    platforms = lib.platforms.unix;
  };
}
