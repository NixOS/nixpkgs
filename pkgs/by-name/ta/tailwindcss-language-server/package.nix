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
  version = "0.0.18";
in
buildNpmPackage {
  pname = "tailwindcss-language-server";
  inherit version;

  src = fetchFromGitHub {
    owner = "tailwindlabs";
    repo = "tailwindcss-intellisense";
    rev = "@tailwindcss/language-server@v${version}";
    hash = "sha256-A2P7AzFciVpXEWOH6hu2+TYKTn23z1iS8mmD0nvsR2Y=";
  };

  makeCacheWritable = true;
  npmDepsHash = "sha256-/vr7PCohzw4QEEOx6+7IAzBM4xC2nxvNb3PLtSUT7YM=";
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
