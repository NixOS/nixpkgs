{ lib
, stdenv
, buildNpmPackage
, fetchFromGitHub
, python3
, darwin
, libsecret
, pkg-config
}:

let
  version = "0.0.14";
in
buildNpmPackage {
  pname = "tailwindcss-language-server";
  inherit version;

  src = fetchFromGitHub {
    owner = "tailwindlabs";
    repo = "tailwindcss-intellisense";
    rev = "@tailwindcss/language-server@v${version}";
    hash = "sha256-EE1Gd0cmcJmyleoXVNtMJ8IKYpQIzRf2F42HOORHbwo=";
  };

  makeCacheWritable = true;
  npmDepsHash = "sha256-gQgGIo/cS0P1B5lSmNpd8WOgucf3RbRk1YOvMXNbxb0=";
  npmWorkspace = "packages/tailwindcss-language-server";

  buildInputs = [ libsecret ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ Security AppKit ]);

  nativeBuildInputs = [ python3 pkg-config ];

  meta = with lib; {
    description = "Intelligent Tailwind CSS tooling for Visual Studio Code";
    homepage = "https://github.com/tailwindlabs/tailwindcss-intellisense";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada];
    mainProgram = "tailwindcss-language-server";
    platforms = platforms.all;
  };
}
