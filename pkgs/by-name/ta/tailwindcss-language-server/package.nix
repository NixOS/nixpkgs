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
  version = "0.0.21";
in
buildNpmPackage {
  pname = "tailwindcss-language-server";
  inherit version;

  src = fetchFromGitHub {
    owner = "tailwindlabs";
    repo = "tailwindcss-intellisense";
    rev = "@tailwindcss/language-server@v${version}";
    hash = "sha256-LMQ+HA74Y0n65JMO9LqCHbDVRiu4dIUvQofFTA03pWU=";
  };

  makeCacheWritable = true;
  npmDepsHash = "sha256-T7YNHunncSv+z86Td1QuBt4dMGF1ipo85ZhW7U9I0Zw=";
  npmWorkspace = "packages/tailwindcss-language-server";

  buildInputs = [ libsecret ] ++ lib.optionals stdenv.hostPlatform.isDarwin (with darwin.apple_sdk.frameworks; [ Security AppKit ]);

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
