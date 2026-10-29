{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v10.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.12";
      hash = "sha512-opT5P1p+CG70xGaveTgq3Q5OZKd7MZ0Rs10x4Tewl6bcPbu4SLo4F0n6RBCInvBKxoR10T11+X0M9dgjKEfucw==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.12";
        hash = "sha512-5AlRS9Ur+GFEc7yio6AjDgZpaHS8tTdQeGWCVrd/aXI8l83+Jiy18zXTkF9TjSr9pi82g6HNlHwMbpiCIes21Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILAsm";
        version = "10.0.12";
        hash = "sha512-KRsTyklCGJ/9OZhUL6REPWjIXvx7Sol9cJrNC5ecgSMIyLvC+xD4v5N7Of8iXPFN+xrANynx2Q12rFkHbxNjdw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILDAsm";
        version = "10.0.12";
        hash = "sha512-lSo2UPmA2/R/yjddf6tzezzbUHQgK716TUxjc6vxm3XjRCrSvCAhZpRb/+BN+4BrHtTdfV/n4fmjniJ4rLj24g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.12";
        hash = "sha512-Bj8DnDfxqaZuKsq5JrkgNlgpexNxM1omyqIVBb7PztrGPvzTO8vWMQ3qvyJc95P1xdPVuukV6I8td+v1S51wFw==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.12";
        hash = "sha512-hBrbpFloNh3BlCDLxPff3ElYmGUuQM2ZTKlYRtGXYak9e+0nDMSmtQcxApMf06f8M4mGyEsGCSscW0BnuJuE2g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILAsm";
        version = "10.0.12";
        hash = "sha512-sKqE1DAxOpf2S3TLJSAFlrA1/Pi01ZDkG2BfX3Z1CAVlAbHUBA8QtPaFAZHxY0WrTU+QYX3SSVZthDNsuUuvYA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILDAsm";
        version = "10.0.12";
        hash = "sha512-lTWbbGOBUmKXj8C+b5wAedhehIBO8wTL9jNVVpsEMZeH4Pld0q7x0qoSsPLNY0luSwz7JeyNk/yyZHsM4HGGUg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.12";
        hash = "sha512-EQ+HtSVgpCYFcKjcQPDhQazwnuy8AeeSoTudz65Kl1/8B7U5JDQ6tmV8uFhT94tXMnEs5XMoaYXcLOsBcgf8gg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.12";
        hash = "sha512-Lsw9zALZkoKvYWMfMbNNcCNH5UcZGfi60Dylr3A7vkUIbHDTY+c0IFLO9I6YKA3pBFCVBeoUOoQuF2m7N8QJ6w==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILAsm";
        version = "10.0.12";
        hash = "sha512-kmDNhnVy23gM+N+vBnMBB/a/J27U30AAapkrLN1tcXMn6DbOB4721XXWVu0oOMljQobIChXBqqVWf65bbAVA/Q==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILDAsm";
        version = "10.0.12";
        hash = "sha512-gd5Wg5d8tRUAEf3kUuq6Ha/FV70VOc5iHOhn1rJgxSLQfVJS/RYhQoKa24cu5VbfFzBtjt2XwnNa9NHLL5B5ew==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.12";
        hash = "sha512-YXd3x+3Wk3Rf4L1Lk1cCWNuHj9chmQw9iHy7hg3OTGi1WSvH7VVZiOiMpg8GXzGjC5aUwwn0vMVFv6ouyRlSPw==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.12";
        hash = "sha512-55sgYLEBsiApC4eMoTXCeqjGhYMtuViG4z4xHFUv3bo3eq0ZxFNgscRMvWRy6E6Awv6dviSWXD3Gs/sP2eJvSw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILAsm";
        version = "10.0.12";
        hash = "sha512-hmEvojeN3G7K389/FNY3DU1qmqC2DrZ6uG9nxZC7eYawcRgsdk9JhBzn7IhpI4qlbVavtTrHyYTizTwK8FLg8A==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILDAsm";
        version = "10.0.12";
        hash = "sha512-SvDXxq3E+GH8hZTaS1e3wLkAzSmoN9iDtQx9BKzuSU8BMlYpRqKs/SKbiHWoOUgfMEpKp2itLwMzgZo+jhHlpg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.12";
        hash = "sha512-K34oso00OhUR1qTIF6l2s7Lf/ey+6wTFa+bmwxp5xjou0/r/DbKV2IUqRvZap6twe+dcRvcXjbB7zVNZJ+qGxA==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.12";
        hash = "sha512-qUics32CIS7BxSac3U+LlxOaaIRDtSuwjUARAS1ZPoLmhETD4Z5FpEE1GQxzKqhlK7IId0V9HuaU6PCWFFw6OQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.12";
        hash = "sha512-wi7jZfGEVTuajiD5Rx/RL5sGRGcHn5d6UU6o/H6IhexDHlVpaPGt5R6JicIcEEietKAYEatuMMzsSnFI26DIbg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.12";
        hash = "sha512-M3cZRbtrCjFV1aJ0eA2MbIBe2CB3XO56dkqBoRjIyhAKo3luCzk7AqStyr5u4/7an2/SF+6ejhazWtiAcdTlsA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.12";
        hash = "sha512-FWJ8ixsfc+snzowYyAUlRGHehPjH9xtmLg0owWDV1Ju9dUeZf+OKuBagE+E/flME5Hhx7rObgcSVTXQak/wvGg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.12";
        hash = "sha512-yxiNGqHQPwU5ecdxXX8eI07UaQ596TQvydUx8f93p3WF2vJyynw7U9zUK0QspzNix2NzmNxMouUjvXAIO+4BTw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.12";
        hash = "sha512-8rDt9QoxwXsA6a0tVl9b4fD5my0EZtXvJndCEFESf/H5hSlqvi26RBwfnvyiz3b8wS2pdP8G6H7xqdRJbSVkwg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.12";
        hash = "sha512-+atcf2Tu2z6hT+MuJQHcHsysHnbw8MS4flOLaPlzhhts6PygqK9g5QDOrSFjOsMoLurbccyr4MxanIP0UEGpkA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.12";
        hash = "sha512-iPpHFMcrH8KdkNomgTAX/T3SoBBTWb9iWVIFhHqFfU4lwXo67QK0JbMA9kG53i1VEYMrdbhQwRzoHyAKF4voBg==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.12";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.12";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.12/aspnetcore-runtime-10.0.12-linux-arm64.tar.gz";
        hash = "sha512-m6mIkFeouKg3EJnx/JnGcQtyP9A1mUEYO5pQQLfZ+38DvAa32tEAlp9D+FLaiLbYQ/bHmDyGaRWUYSBDIz8uAg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.12/aspnetcore-runtime-10.0.12-linux-x64.tar.gz";
        hash = "sha512-xIn8Op3MhfJPLVLpqBtG/fUa/8ijYNAI29Xjt85SSWmtxKVPVVrRPim4IvWe0crpeFYIy6wigvLJxP2kXCHH0Q==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.12/aspnetcore-runtime-10.0.12-osx-arm64.tar.gz";
        hash = "sha512-vdmi551b2b10muSGlJbqQ1uURFvCyI6fv7qPfljOb3yQGsaIVdbxcOCxjlFPwPopluvPoOcdQW4RotZBboI1IQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.12/aspnetcore-runtime-10.0.12-osx-x64.tar.gz";
        hash = "sha512-rSN0TYzwjYAOYFy+cPaulyhrXH6eInpztrkhPdzUY7VemJo4mHedm5aBFq6cFPddxU4VPgrEVq5wF3TjpLaROw==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.12";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.12/dotnet-runtime-10.0.12-linux-arm64.tar.gz";
        hash = "sha512-rB4AkDkQhbpwx0V62qqPbMINwha5s2i0InpCfeJxcI14M4DHuVW3vkiX/ySEn75cO37Byxw4NFpyXemjgSKA6w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.12/dotnet-runtime-10.0.12-linux-x64.tar.gz";
        hash = "sha512-WDiP3eTxO9cDx6b33vszALF+Qrpf6LylAGb4D2SsdAZiDc37Sswe/3mSdQyMxc/4Np3RLQlzDIqeh2DWAy9/bg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.12/dotnet-runtime-10.0.12-osx-arm64.tar.gz";
        hash = "sha512-0bQiwq/stedBQwWEw+GIfV4PLfMhqA1JL90T2Mf5lXnw278040i8USyydvD4a0ZFQjoDLe1SgIt0q46w178qbQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.12/dotnet-runtime-10.0.12-osx-x64.tar.gz";
        hash = "sha512-xQGTV8nY++MLSeyPga6FvlanhNi0t19HDpMVg8OeCCdzwImzl4WzIncKKYqwhjbGsw5pWiOX/DEQYPc8mHQ7SA==";
      };
    };
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.112";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.112/dotnet-sdk-10.0.112-linux-arm64.tar.gz";
        hash = "sha512-KXN4s0fUT2Gf7IaJgyOJTxQWKdwKs7cCXIbwJaejHJjm+odO8sRz5zvXPPNwzOUVTfRxzHj6c0Ird1i06j9cag==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.112/dotnet-sdk-10.0.112-linux-x64.tar.gz";
        hash = "sha512-GslJ39OSmFXjoQKlsS+EOWenhK0tkR38//ar34Gi54vM8l3cBVVH3gKzYTO/eSqvl/y6jbiqa1KsLgGLhpNdBQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.112/dotnet-sdk-10.0.112-osx-arm64.tar.gz";
        hash = "sha512-HP4Soa44PuFfpGNsFjDaeGGWPdxNBSLEEtY8kFcOqH0QHmvf973CcD/EKl2c4y5ztUWYQcKZASgnmgrmQglKOA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.112/dotnet-sdk-10.0.112-osx-x64.tar.gz";
        hash = "sha512-gVez/iSjlD2lfjnaCFxXxDRd1M3vAAWJNbdTzs+AQLsCKkyTaO1BejrVDeG/iVCWQJpL/rrFXUZtW14eqPx1QA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk = sdk_10_0;

  sdk_10_0 = sdk_10_0_1xx;
}
