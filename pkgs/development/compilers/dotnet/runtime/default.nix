{ stdenv
, fetchurl
, libunwind
, openssl
, icu
, libuuid
, zlib
, curl
}:

let
  rpath = stdenv.lib.makeLibraryPath [ stdenv.cc.cc libunwind libuuid icu openssl zlib curl ];
in
  stdenv.mkDerivation rec {
    version = "2.1.7";
    name = "dotnet-${version}";

    src = fetchurl {
      url = "https://download.visualstudio.microsoft.com/download/pr/085b427b-66f6-4cf5-bee3-5f4cbef2b72c/9c1ad276cf957258d123a3b268ec9304/aspnetcore-runtime-2.1.7-linux-x64.tar.gz";
      # use sha512 from the download page
      sha512 = "2nkihh8n2ncsjlkj89vkxi8k5v4z9nhw4600s2c701azcvxaq85mizb7q0bqd6rcj0270drw7jqbrlkxiy3yvqrkdwin0cnwbwprvzy";
    };

    unpackPhase = ''
      mkdir src
      cd src
      tar xvzf $src
    '';

    buildPhase = ''
      runHook preBuild
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" ./dotnet
      patchelf --set-rpath "${rpath}" ./dotnet
      find -type f -name "*.so" -exec patchelf --set-rpath "${rpath}" {} \;
      echo -n "dotnet version: "
      ./dotnet --info
      runHook postBuild
    '';

    dontPatchELF = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp -r ./ $out
      ln -s $out/dotnet $out/bin/dotnet
      runHook postInstall
    '';

    meta = with stdenv.lib; {
      homepage = https://dotnet.github.io/;
      description = ".NET Core Runtime ${version}";
      # if dotnet sdk is installed then use it instead of the runtime pkg
      # refer to sdk/default.nix
      priority = 0;
      platforms = [ "x86_64-linux" ];
      maintainers = with maintainers; [ ghuntley kuznero ];
      license = licenses.mit;
    };
  }
