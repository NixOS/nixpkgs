{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  python,
}:
let
  version = "3.4.0";

  inherit (python) pythonVersion;

  Srcs =
    let
      getSrcFromPypi =
        {
          platform,
          dist,
          hash,
        }:
        fetchPypi {
          inherit
            version
            platform
            dist
            hash
            ;
          pname = "pulsar_client";
          format = "wheel";
          python = dist;
          abi = dist;
        };
    in
    {
      "3.9-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux_2_17_x86_64.manylinux2014_x86_64";
        dist = "cp39";
        hash = "sha256-1P5ArMoLZiUkHUoQ/mJccbNj5/7el/op+Qo6cGQ33xE=";
      };
      "3.9-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux_2_17_aarch64.manylinux2014_aarch64";
        dist = "cp39";
        hash = "sha256-11JQZRwMLtt7sK/JlCBqqRyfTVIAVJFN2sL+nAkQgvU=";
      };
      "3.9-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_10_15_universal2";
        dist = "cp39";
        hash = "sha256-dwTGZKosgBr0wtOljp2P+u7xLOig9xcS6Rh/mpbahW8=";
      };
      "3.9-x86_64-darwin" = getSrcFromPypi {
        platform = "macosx_10_15_universal2";
        dist = "cp39";
        hash = "sha256-dwTGZKosgBr0wtOljp2P+u7xLOig9xcS6Rh/mpbahW8=";
      };
      "3.10-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux_2_17_x86_64.manylinux2014_x86_64";
        dist = "cp310";
        hash = "sha256-swp1kuQsdgNOmo1k1C3VurNhQl+GneVi6cytaY4ZzYg=";
      };
      "3.10-aarch64-linux" = getSrcFromPypi {
        platform = "musllinux_1_1_aarch64";
        dist = "cp310";
        hash = "sha256-1ZYwkKeKVkS6JfQdo6bUnqPwDJcrCVuv82WRbcJGQmo=";
      };
      "3.10-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_10_15_universal2";
        dist = "cp310";
        hash = "sha256-6/mdtSRP9pR5KDslYhsHBJKsxLtkPRYthrkDh8tv2yo=";
      };
      "3.10-x86_64-darwin" = getSrcFromPypi {
        platform = "macosx_10_15_universal2";
        dist = "cp310";
        hash = "sha256-6/mdtSRP9pR5KDslYhsHBJKsxLtkPRYthrkDh8tv2yo=";
      };
      "3.11-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux_2_17_x86_64.manylinux2014_x86_64";
        dist = "cp311";
        hash = "sha256-M1cd6ZzYmDSfF5eLpi4rg56gJ1+3Bn8xv19uv+rgmH0=";
      };
      "3.11-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux_2_17_aarch64.manylinux2014_aarch64";
        dist = "cp311";
        hash = "sha256-+HQ8MgqpZ5jSDK+pjql6aMQpX8SHLCOs1eAS/TbLBro=";
      };
      "3.11-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_10_15_universal2";
        dist = "cp311";
        hash = "sha256-EZUvsCLuct6/U7Fp9EgvncXIkL4BSa6Yd5hks6IfG9M=";
      };
      "3.11-x86_64-darwin" = getSrcFromPypi {
        platform = "macosx_10_15_universal2";
        dist = "cp311";
        hash = "sha256-EZUvsCLuct6/U7Fp9EgvncXIkL4BSa6Yd5hks6IfG9M=";
      };
      "3.12-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux_2_17_x86_64.manylinux2014_x86_64";
        dist = "cp312";
        hash = "sha256-xgbATzVzQQQvpsdUd959IgT3rlCqKcL3SyTlTIX0f5Y=";
      };
      "3.12-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux_2_17_aarch64.manylinux2014_aarch64";
        dist = "cp312";
        hash = "sha256-8gK4Th9oPWRnLdGXERRgCuLlw3NVhyhv+b+0MThfCOg=";
      };
      "3.12-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_10_15_universal2";
        dist = "cp312";
        hash = "sha256-Hgd6SDm+Pq094/BbTCRCadyi3wf0fOoLkFRMfp3BZC8=";
      };
      "3.12-x86_64-darwin" = getSrcFromPypi {
        platform = "macosx_10_15_universal2";
        dist = "cp312";
        hash = "sha256-Hgd6SDm+Pq094/BbTCRCadyi3wf0fOoLkFRMfp3BZC8=";
      };
    };
in
buildPythonPackage {
  pname = "pulsar-client";
  inherit version;

  format = "wheel";

  src =
    Srcs."${pythonVersion}-${stdenv.hostPlatform.system}"
      or (throw "Unsupported '${pythonVersion}-${stdenv.hostPlatform.system}' target");

  meta = with lib; {
    description = "Client for pulsar";
    homepage = "https://pypi.org/project/pulsar-client/";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
