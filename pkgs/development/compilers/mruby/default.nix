{ lib, stdenv, ruby, bison, rake, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "mruby";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner   = "mruby";
    repo    = "mruby";
    rev     = version;
    sha256  = "sha256-C3K7ZooaOMa+V2HjxwiKxrrMb7ffl4QAgPsftRtb60c=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2022-1212.patch";
      url = "https://github.com/mruby/mruby/commit/3cf291f72224715942beaf8553e42ba8891ab3c6.patch";
      sha256  = "1bl8wm6v7v18zgxqvm4kbn8g97a75phzrdah279xqw1qvplbd2w7";
    })
  ];

  nativeBuildInputs = [ ruby bison rake ];

  # Necessary so it uses `gcc` instead of `ld` for linking.
  # https://github.com/mruby/mruby/blob/35be8b252495d92ca811d76996f03c470ee33380/tasks/toolchains/gcc.rake#L25
  preBuild = if stdenv.isLinux then "unset LD" else null;

  installPhase = ''
    mkdir $out
    cp -R include build/host/{bin,lib} $out
  '';

  doCheck = true;

  meta = with lib; {
    description = "An embeddable implementation of the Ruby language";
    homepage = "https://mruby.org";
    maintainers = [ maintainers.nicknovitski ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
