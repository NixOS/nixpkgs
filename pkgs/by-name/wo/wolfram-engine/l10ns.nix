{
  lib,
  requireFile,
  lang,
  majorVersion ? null,
}:

let
  allVersions =
    lib.flip map
      # N.B. Versions in this list should be ordered from newest to oldest.
      [
        {
          version = "15.0.0";
          lang = "en";
          language = "English";
          hash = "sha256-U1LR5UTbdCqa5JN3DluH4Iq7YF+KfZbZx35YVVHAMu4=";
          installer = "WolframEngine_15_LIN.sh";
        }
        {
          version = "14.3.0";
          lang = "en";
          language = "English";
          hash = "sha256-hhYpzHGFkqKsqWmh22pDLPGJ0rlb+L2fYeJj3WF1Ntw=";
          installer = "WolframEngine_14.3.0_LIN.sh";
        }
        {
          version = "14.2.1";
          lang = "en";
          language = "English";
          hash = "sha256-HcI3TbS+pZWiMABkfp+cdNSga9nllNWNZcB6sarsb/o=";
          installer = "WolframEngine_14.2.1_LIN.sh";
        }
        {
          version = "14.1.0";
          lang = "en";
          language = "English";
          hash = "sha256-SL47mtlaU1rY+VvOOQXywIa8BBQneYKO5sPaE0fdrc8=";
          installer = "WolframEngine_14.1.0_LIN.sh";
        }
        {
          version = "14.0.0";
          lang = "en";
          language = "English";
          hash = "sha256-Geh+XfpqGz+CKo9P+1OqsbW9bwFmB7LrKcY6A0BtLNo=";
          installer = "WolframEngine_14.0.0_LINUX.sh";
        }
        {
          version = "13.3.0";
          lang = "en";
          language = "English";
          hash = "sha256-lhBqyO1tDiIaaNhGEXYVwUAlMg+Sfl4O2VsZZe2mjjE=";
          installer = "WolframEngine_13.3.0_LINUX.sh";
        }
        {
          version = "13.2.0";
          lang = "en";
          language = "English";
          hash = "sha256-RPgZlTIDT9AQRIJ7/jszf04eSw2l+DRtl6LgSIwNb/c=";
          installer = "WolframEngine_13.2.0_LINUX.sh";
        }
        {
          version = "13.1.0";
          lang = "en";
          language = "English";
          hash = "sha256-wJDAm9/GInYTmpYmK1E0yT7tUrf+lsSinR0pNK6fqZg=";
          installer = "WolframEngine_13.1.0_LINUX.sh";
        }
        {
          version = "13.0.1";
          lang = "en";
          language = "English";
          hash = "sha256-6uGu0IQ5DitEBAFlDkqBVn2ZBMIuhTMPIALUUNqJPec=";
          installer = "WolframEngine_13.0.1_LINUX.sh";
        }
        {
          version = "12.3.1";
          lang = "en";
          language = "English";
          hash = "sha256-2+qIJY/ztWcIlIGZGSq0np3HqMg+vSmuAFKkVmB3KMU=";
          installer = "WolframEngine_12.3.1_LINUX.sh";
        }
        {
          version = "12.2.0";
          lang = "en";
          language = "English";
          hash = "sha256-qeHPYKGSD5jY6AwJNWFGRE9NRU0ueBG4/FU2NgBZPcs=";
          installer = "WolframEngine_12.2.0_LINUX.sh";
        }
      ]
      (
        {
          version,
          lang,
          language,
          hash,
          installer,
        }:
        {
          inherit version lang;
          name = "wolfram-engine-${version}" + lib.optionalString (lang != "en") "-${lang}";
          src = requireFile {
            name = installer;
            message = ''
              This nix expression requires that ${installer} is
              already part of the store. Download the file from
              https://www.wolfram.com/engine/ and add it to the nix store
              with nix-store --add-fixed sha256 <FILE>.
            '';
            inherit hash;
          };
        }
      );
  minVersion =
    if majorVersion == null then
      lib.elemAt (builtins.splitVersion (lib.elemAt allVersions 0).version) 0
    else
      majorVersion;
  maxVersion = toString (1 + builtins.fromJSON minVersion);
in
lib.findFirst (
  l: (l.lang == lang && l.version >= minVersion && l.version < maxVersion)
) (throw "Version ${minVersion} in language ${lang} not supported") allVersions
