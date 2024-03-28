{ lib
, fetchFromGitHub
, php
}:

(php.withExtensions({ enabled, all }: enabled ++ (with all; [ ast ]))).buildComposerProject (finalAttrs: {
  pname = "discordphp";
  version = "7.3.5";

  src = fetchFromGitHub {
    owner = "discord-php";
    repo = "discordphp";
    rev = "ac16fdf6e9a9d20003edbca734c386ddcf616eda";
    hash = "sha256-pevzLJfEbI98jtM34xWIzhU12hQzwHrxMYoAgrBMFbo=";
  };

  vendorHash = "sha256-S864hmBh9VjRTDRbL1JJXaKXLZPHevngAwAJumgatWo=";
  composerLock = ./composer.lock;

  meta = {
    description = "An API to interact with the popular messaging app Discord ";
    homepage = "https://github.com/discord-php/DiscordPHP";
    license = lib.licenses.mit;
    longDescription = ''
       A wrapper for the official Discord REST, gateway and voice APIs. Documentation is available here, albeit limited at the moment, as well as a class reference.
    '';
    maintainers = with lib.maintainers;  [ mrtuxa ];
  };
})
