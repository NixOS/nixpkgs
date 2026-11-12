{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v8.0 (maintenance)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.31";
      hash = "sha512-IJZNYlvt7fSK2NBdHV03ethT05+zls4Z3IpfdHCL6NqkZwSp2jwwHUzSmPFMOC//e5XKxoYDPlDNI49pPg6IvQ==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.31";
        hash = "sha512-eZyl+7Lc6iAQMLugc3aoGCHIQHNPhp/z7Y3KjDBVxM2Xrn2oV6lOAcuIsqCZYMl3cLwvPQCTcZR6u0eprk2MZA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.31";
        hash = "sha512-sVXSUEY4xKRqemHAFL17RZvQvjASKX106kzYi5RUYi8Rc1Gu8LLwc/mfKLAJdmxbIzyek+kf0ERGeuVUNPaCUQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.31";
        hash = "sha512-iLmipFPaSmkTlFuuXzK9VxZ1R3aL77y1QIJ8h4fII02faWmO1keb6Zul7lFSRVAi9Zh2jFBiezYXQnrJbxWAnA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.31";
        hash = "sha512-fiKe3j7r7m8ByBtUt/vL0HfUwHsYGxnNXmDDW+DgC+UAItw8tKULBQ80fjxV8XC7rrJIBLrFzDCylkrK0GYYdw==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.31";
        hash = "sha512-7Gq7oIx+qc9M6Om1fGuJUPb1crlZ6YXx8dKYSG1Ly7WB3UbqV0CnyH7VA1s64Dx00QVHTsOIBWPnBhqub+6eGA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.31";
        hash = "sha512-CECd0hR9BAtAvvLV7fluqpx/TvIu2rcY7LGx6OZ5/ns66n5Tbz5yDSTrKR+C15ExIpz9D/zg4TnZwOqauQm5NQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.31";
        hash = "sha512-dJzphqP88n9+LwzDYLKU5x3JdzgPIu47g4WV5eGTd/H6Zfc9mlb1/58azGjUrTX33+SLFtCzGm0fmd+KnliP1g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.31";
        hash = "sha512-x8+6KJjRkEDmhWeBzEA7wRLS0z4Bn4uvsTs8XZ6EcLWCbpHe2ezqc8yj28rLk3AbTaoAIaYeB356x6k9F3Si8g==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.31";
        hash = "sha512-ekZeYPRF4trWaZkh2RgJeu4UC1OcV+Y9qToL8vNi++dzuGKdM+QdkiKMt02AU9mmTtfKAKyDKJWQXyf7vHNSLA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.31";
        hash = "sha512-CgZTEIxVCMSSPkUaO2UGOPg+MOsFuMQKb4UGLLQ1tfOm8HTWUGAP5jLWMW6HfHaHbHnPJimH9b8q6fOHsVuLPw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.31";
        hash = "sha512-T+uwK5AsaYQjQiE22L01GGDQFFxYlfDh1XQjBRRWH71D51ysCv66f2FB/wtQfNXFd4H0eH3x3AmXSiuXh2PVjw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.31";
        hash = "sha512-KhnLtIs0PHDbkxz4WZZCaU8oIqDazGCwMGerZ4vyAXCnGVlbClVRGVFiXWEaeirtn2Zzqb67azRaOcchkkxkfA==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.31";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.31";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.31/aspnetcore-runtime-8.0.31-linux-arm64.tar.gz";
        hash = "sha512-pocdAChg2MuSA2DJj2/bT6hHDTQTm4O5AK7VEsQSfn7SIdGdbh2Iuz9R8+U2nmgPXlF+XDUYmTWBKorXdPVcWg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.31/aspnetcore-runtime-8.0.31-linux-x64.tar.gz";
        hash = "sha512-2HDJSNVGCZOYhnJeKdi5wjUnfp1jstd63vzzhWO2aTLEgPG5gPHxg+KyrBwJ/AZnMOoICt8RSO/dZUsVA+aewA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.31/aspnetcore-runtime-8.0.31-osx-arm64.tar.gz";
        hash = "sha512-hBUQPzGfSAW1tvRHsXiHuUc5fq79gggSBtvkxvXDbMM4psWUWjdzwpKA5yVhK77JNIT9AUszMNMqVWt+TLxL9w==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.31/aspnetcore-runtime-8.0.31-osx-x64.tar.gz";
        hash = "sha512-ScS8Q+gJYPDDNMCJE9sPDXWR8wvemjsPw3bn5YYovFb7/U6Uc0Brm/5T2WcF9HPqwRLDqvLdha1NcJklBAuGuw==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.31";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.31/dotnet-runtime-8.0.31-linux-arm64.tar.gz";
        hash = "sha512-3cZrZek3fn84Bbp4oOyb6FffuW34ZjSd8r+WMxKTPGY+XbmL2EQ3idz2RXyo+BVARFCUbvh1YhF9Mmw6RCNGbA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.31/dotnet-runtime-8.0.31-linux-x64.tar.gz";
        hash = "sha512-8za97FjVS/UNdKGzjvqC9ykNl2vS7Zi4RevLrELPDYzvUEaE/AiNSwX5hze5lr8zAuUr2cIwBd6ufGB4CyZS+w==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.31/dotnet-runtime-8.0.31-osx-arm64.tar.gz";
        hash = "sha512-GWPSqzeY79wrMwNO9X1CUoSaBmojE85ipXTlVtGeXpga/hPJVF621ZQ3hJcj4cg1DxD4BovPpreigVoHJju4sw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.31/dotnet-runtime-8.0.31-osx-x64.tar.gz";
        hash = "sha512-10x0M+4x3SpdZnLvr+6yotQ/qEsZsdQeQSrK3+BKTNQEbN3VHA4QJ98KI/pgZYh+ASOlxlQN4ecxdI0hynW9tg==";
      };
    };
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.131";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.131/dotnet-sdk-8.0.131-linux-arm64.tar.gz";
        hash = "sha512-ROJjWPck6gsnuo1LflD7StssPTmNZherp46m4sD6p50cphk6lX1M2NInj9H4Me2ePfSuFozYf4bpP7ul1nvimg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.131/dotnet-sdk-8.0.131-linux-x64.tar.gz";
        hash = "sha512-phgtPxNsUkSF2iSBVrJjAS66cBeaCEkTG1MxVIdw/BSaQjR/eGX9vU+BBXso+mjCOVqw6VSfLIomgxD0iiME6w==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.131/dotnet-sdk-8.0.131-osx-arm64.tar.gz";
        hash = "sha512-SUYa1MhX6L3qIDW80kIsrVtxWZofA7zc+e303lQ0gugooY9fDPC8Kehq6JtfI2GPpV5QtLMyff4IdirXNfuc8g==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.131/dotnet-sdk-8.0.131-osx-x64.tar.gz";
        hash = "sha512-hwzCOeAu+ZZ0WIRToRnLPtsSlUVOTo4ftUuMMJpHkpcD7W0u/YNL1508ePtwKidQcWIObDhp0N72xtKtpfm4dg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk = sdk_8_0;

  sdk_8_0 = sdk_8_0_1xx;
}
