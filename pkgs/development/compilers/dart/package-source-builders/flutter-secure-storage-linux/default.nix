{
  stdenv,
  libgcrypt,
  libgpg-error,
  libsecret,
  jsoncpp,
}:

{ version, src, ... }:

stdenv.mkDerivation {
  pname = "flutter-secure-storage-linux";
  inherit version src;
  inherit (src) passthru;

  propagatedBuildInputs = [
    libsecret
    jsoncpp

    # hack: these are dependencies of libsecret and ideally shouldn't be here,
    #       but they're currently required because the derivation that actually
    #       needs the libsecret headers & cflags is the final flutter app, NOT
    #       this pub package (because flutter compiles everything at the end instead
    #       of having intermediate objects like the more traditional workflow
    #       stdenv is built for). this means that, since libsecret's headers
    #       depend on libgcrypt & libgpg-error, they _also_ need to be present
    #       in the final derivation's inputs (and, if they had build inputs
    #       themselves, we'd also need to add these here, etc. ad infinitum)
    libgcrypt
    libgpg-error
  ];

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    ln -s '${src}'/* "$out"

    runHook postInstall
  '';

  __structuredAttrs = true;
}
