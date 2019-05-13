{ stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, pkgconfig, which
, gettext, libffi, libiconv, libtasn1
}:

stdenv.mkDerivation rec {
  pname = "p11-kit";
  version = "0.23.15";

  src = fetchFromGitHub {
    owner = "p11-glue";
    repo = pname;
    rev = version;
    sha256 = "0kf7zz2cvd6j09qkff3rl3wfisva82ia1z9h8bmy4ifwkv4yl9fv";
  };

  patches = [
    (fetchpatch {
      # https://github.com/p11-glue/p11-kit/issues/212
      url = "https://github.com/p11-glue/p11-kit/commit/2a474e1fe8f4bd8b4ed7622e5cf3b2718a202562.patch";
      sha256 = "13wi32hpzilvzxn57crn79h88q38jm2fzd5zxj4wnhv9dhwqr6lg";
    })
    (fetchpatch {
      # https://github.com/p11-glue/p11-kit/issues/220
      url = "https://github.com/p11-glue/p11-kit/commit/e2170b295992cb7fdf115227a78028ac3780619f.patch";
      sha256 = "0433d8drfxaabsxwkkl4kr0jx8jr2l3a9ar11szipd9jwvrqnyr7";
    })
  ];

  outputs = [ "out" "dev"];
  outputBin = "dev";

  nativeBuildInputs = [ autoreconfHook pkgconfig which ];
  buildInputs = [ gettext libffi libiconv libtasn1 ];

  autoreconfPhase = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--without-trust-paths"
  ]; # TODO: store trust anchors in a directory common to Nix and NixOS

  enableParallelBuilding = true;

  doCheck = true;

  installFlags = [ "exampledir=\${out}/etc/pkcs11" ];

  meta = with stdenv.lib; {
    description = "Library for loading and sharing PKCS#11 modules";
    longDescription = ''
      Provides a way to load and enumerate PKCS#11 modules.
      Provides a standard configuration setup for installing
      PKCS#11 modules in such a way that they're discoverable.
    '';
    homepage = https://p11-glue.github.io/p11-glue/p11-kit.html;
    platforms = platforms.all;
    license = licenses.bsd3;
  };
}
