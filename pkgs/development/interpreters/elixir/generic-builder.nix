{ stdenv, fetchFromGitHub, makeWrapper, erlang, rebar, coreutils, curl, bash }:

{ version
, sha256 ? null
, src ? fetchFromGitHub { owner = "elixir-lang"; repo = "elixir"; rev = "v${version}"; inherit sha256; }
, enableDebugInfo ? false
, preUnpack ? "", postUnpack ? ""
, patches ? [], patchPhase ? "", prePatch ? "", postPatch ? ""
, configureFlags ? [], configurePhase ? "", preConfigure ? "", postConfigure ? ""
, buildPhase ? "", preBuild ? "", postBuild ? ""
, installPhase ? "", preInstall ? "", postInstall ? ""
, checkPhase ? "", preCheck ? "", postCheck ? ""
, fixupPhase ? "", preFixup ? "", postFixup ? ""
}:

let
  inherit (stdenv.lib) optionalAttrs optionalString;

in stdenv.mkDerivation ({
  name = "elixir-${version}";

  inherit src version;

  debugInfo = enableDebugInfo;
  buildFlags = optionalString enableDebugInfo "ERL_COMPILER_OPTIONS=debug_info";

  buildInputs = [ erlang rebar makeWrapper ];

  # Elixir expects that UTF-8 locale to be set (see https://github.com/elixir-lang/elixir/issues/3548).
  # In other cases there is warnings during compilation.
  LANG = "en_US.UTF-8";
  LC_TYPE = "en_US.UTF-8";

  setupHook = ./setup-hook.sh;

  preBuild = ''
    # The build process uses ./rebar. Link it to the nixpkgs rebar
    rm -v rebar
    ln -s ${rebar}/bin/rebar rebar

    substituteInPlace Makefile \
      --replace /usr/local $out
  '';

  postFixup = ''
    # Elixir binaries are shell scripts which run erl. Add some stuff
    # to PATH so the scripts can run without problems.

    for f in $out/bin/*; do
     b=$(basename $f)
      if [ $b == "mix" ]; then continue; fi
      wrapProgram $f \
        --prefix PATH ":" "${erlang}/bin:${coreutils}/bin:${curl.bin}/bin:${bash}/bin" \
        --set CURL_CA_BUNDLE /etc/ssl/certs/ca-certificates.crt
    done

    substituteInPlace $out/bin/mix \
      --replace "/usr/bin/env elixir" "${coreutils}/bin/env elixir"
  '';

  meta = with stdenv.lib; {
    homepage = "http://elixir-lang.org/";
    description = "A functional, meta-programming aware language built on top of the Erlang VM";

    longDescription = ''
      Elixir is a functional, meta-programming aware language built on
      top of the Erlang VM. It is a dynamic language with flexible
      syntax and macro support that leverages Erlang's abilities to
      build concurrent, distributed and fault-tolerant applications
      with hot code upgrades.
    '';

    license = licenses.epl10;
    platforms = platforms.unix;
    maintainers = with maintainers; [ the-kenny havvy couchemar ];
  };
}
// optionalAttrs (preUnpack != "")      { inherit preUnpack; }
// optionalAttrs (postUnpack != "")     { inherit postUnpack; }
// optionalAttrs (patches != [])        { inherit patches; }
// optionalAttrs (patchPhase != "")     { inherit patchPhase; }
// optionalAttrs (configureFlags != []) { inherit configureFlags; }
// optionalAttrs (configurePhase != "") { inherit configurePhase; }
// optionalAttrs (preConfigure != "")   { inherit preConfigure; }
// optionalAttrs (postConfigure != "")  { inherit postConfigure; }
// optionalAttrs (buildPhase != "")     { inherit buildPhase; }
// optionalAttrs (preBuild != "")       { inherit preBuild; }
// optionalAttrs (postBuild != "")      { inherit postBuild; }
// optionalAttrs (checkPhase != "")     { inherit checkPhase; }
// optionalAttrs (preCheck != "")       { inherit preCheck; }
// optionalAttrs (postCheck != "")      { inherit postCheck; }
// optionalAttrs (installPhase != "")   { inherit installPhase; }
// optionalAttrs (preInstall != "")     { inherit preInstall; }
// optionalAttrs (postInstall != "")    { inherit postInstall; }
// optionalAttrs (fixupPhase != "")     { inherit fixupPhase; }
// optionalAttrs (preFixup != "")       { inherit preFixup; }
// optionalAttrs (postFixup != "")      { inherit postFixup; }
)
