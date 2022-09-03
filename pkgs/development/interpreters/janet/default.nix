{ lib, stdenv, fetchFromGitHub, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "janet";
  version = "1.24.1";

  src = fetchFromGitHub {
    owner = "janet-lang";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uGbaoWJAWbSQ7QkocU7gFZUiWb0GD8mtuO7V0sUXTv0=";
  };

  # This release fails the test suite on darwin, remove when debugged.
  # See https://github.com/NixOS/nixpkgs/pull/150618 for discussion.
  patches = lib.optionals stdenv.isDarwin ./darwin-remove-net-test.patch;

  postPatch = ''
    substituteInPlace janet.1 \
      --replace /usr/local/ $out/
  '';

  nativeBuildInputs = [ meson ninja ];

  mesonFlags = [ "-Dgit_hash=release" ];

  doCheck = true;

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/janet --help
  '';

  meta = with lib; {
    description = "Janet programming language";
    homepage = "https://janet-lang.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ andrewchambers peterhoeg ];
    platforms = platforms.all;
    # Marked as broken when patch is applied, see comment above patch.
    broken = stdenv.isDarwin;
  };
}
