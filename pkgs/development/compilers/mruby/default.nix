{ stdenv, ruby, bison, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "mruby-${version}";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner   = "mruby";
    repo    = "mruby";
    rev     = version;
    sha256  = "0pw72acbqgs4n1qa297nnja23v9hxz9g7190yfx9kwm7mgbllmww";
  };

  patches = [
    ./0001-Disables-IO-isatty-test-for-sandboxed-builds.patch
  ];

  nativeBuildInputs = [ ruby bison ];

  # Necessary so it uses `gcc` instead of `ld` for linking.
  # https://github.com/mruby/mruby/blob/35be8b252495d92ca811d76996f03c470ee33380/tasks/toolchains/gcc.rake#L25
  preBuild = if stdenv.isLinux then "unset LD" else null;

  installPhase = ''
    mkdir $out
    cp -R build/host/{bin,lib} $out
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "An embeddable implementation of the Ruby language";
    homepage = https://mruby.org;
    maintainers = [ maintainers.nicknovitski ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
