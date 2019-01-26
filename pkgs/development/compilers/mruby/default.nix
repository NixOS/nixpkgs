{ stdenv, ruby, bison, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "mruby-${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner   = "mruby";
    repo    = "mruby";
    rev     = version;
    sha256  = "1r6w1asjshff43ymdwa6xmrkggza99mi2kw88k7ic6ag2j81hcj5";
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
