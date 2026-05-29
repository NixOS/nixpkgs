{
  lib,
  stdenv,
  fetchFromGitHub,
  erlang,
  pam,
  perl,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yaws";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "erlyaws";
    repo = "yaws";
    rev = "yaws-${finalAttrs.version}";
    hash = "sha256-JuQ1En9PwplW28n7H3degRFYzpqlqVzJZUCBvbl3Ev0=";
  };

  configureFlags = [ "--with-extrainclude=${pam}/include/security" ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    erlang
    pam
    perl
  ];

  postInstall = ''
    sed -i "s#which #type -P #" $out/bin/yaws
  '';

  meta = {
    description = "Webserver for dynamic content written in Erlang";
    mainProgram = "yaws";
    homepage = "https://github.com/erlyaws/yaws";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };

})
