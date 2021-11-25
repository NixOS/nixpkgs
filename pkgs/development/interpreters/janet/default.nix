{ lib, stdenv, fetchFromGitHub, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "janet";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "janet-lang";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TzJbHmHIySlf3asQ02HOdehMR+s0KkPifBiaQ4FvFCg=";
  };

  # we don't have /usr/bin/env in the sandbox, so substitute for a proper,
  # absolute path to janet
  postPatch = ''
    substituteInPlace jpm \
      --replace '/usr/bin/env janet' $out/bin/janet \
      --replace /usr/local/lib/janet $out/lib \
      --replace /usr/local           $out

    substituteInPlace janet.1 \
      --replace /usr/local/lib/janet $out/lib
  '';

  nativeBuildInputs = [ meson ninja ];

  mesonFlags = [ "-Dgit_hash=release" ];

  doCheck = true;

  meta = with lib; {
    description = "Janet programming language";
    homepage = "https://janet-lang.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ andrewchambers peterhoeg ];
    platforms = platforms.all;
  };
}
