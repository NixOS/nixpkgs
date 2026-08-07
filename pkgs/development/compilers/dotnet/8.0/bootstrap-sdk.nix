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
      version = "8.0.28";
      hash = "sha512-25Dq9XizzfIQjakKHnUXtXm3bCwmXUb/2VJOd9/SR02auZmpECEmjHWK8Z6bqJMUN6DlTJO40Ee+3NJo6TB8SA==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.28";
        hash = "sha512-dhcv0RCwuaFywQZi/kLYCBSfAtA3jlsL0+c9xzvytM0lg9oglZREi7alF5PVlTx06Gc6YAOAiCAG4z3kUwbsVg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.28";
        hash = "sha512-R4Dc3I3ItUEUUNcbjM8QvrJSXq1p/SENQq7i4HQlA1yeaUS2FiAMYQqEqZGzrBf+zp0QFuD6l7dmGTja0jpLrQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.28";
        hash = "sha512-6WhlpxpTJcHEc56F8JVb+qTlQ5hC6b7cCu89zwwK11D8N7gEq5jCEY4dp4+jYmTik1Js8dTTL/+PnzlYB40v1g==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.28";
        hash = "sha512-Xng4I7/WzOualFuJ+wILMKJQG6A2mjKbxQvqCF1NEXO9K16Ee+3RApUS62LujZLRTAa9lYsQ89nMxy0QIkOSuA==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.28";
        hash = "sha512-JQCsYW+a9ioj2DxJtu1tm6U4SoQzPWv6RFMlIJbrZOds3cgp5ZtGcEH9A9Tz2UGhv0o3k4zL43gUxM5DsPyVbA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.28";
        hash = "sha512-DUFIs9EMHZrnaqwoE1+Io/Xne8c4IuqOv0Oarg2oE5IuDy7C/RJIsjwSJ4NiDFOPePc9g0M41xrp2sDVkeXtOg==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.28";
        hash = "sha512-yH0BFhF9hejIic1q/YpaxGeghjke12YdaYHyZiuTWAClduyJQ3JLnWFGYszZgsQQ9ShvbRfZrtGxTeccx5WOBA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.28";
        hash = "sha512-LPN+nh23aQW406l3/s1OxK/yYPtfnAA5zEpDIxgdDGimY8YnrtWESqpD5t6+5ZgXwOlQN0ZMpjgDeJwD1RGOXg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.28";
        hash = "sha512-5vfIslziwBaRxgks/sCebdUSEaTeIiHweYXMs6KkAD4tNg9TIh5lPx1rTFP87EFeTmdsJ+zhgWeQ3f7jJO/ugA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.28";
        hash = "sha512-NVbh0p232jfnJhkYLzSxUP0SaG/CQU7NCo03HmpJ1axBvbYEHNm25bk/7MPZuWWWDXu1Lm2rXnEp+M38mZon4Q==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.28";
        hash = "sha512-X+aEsykeX85ZjOZ84A3UxnZu3AP3EC+QTskYTxA4b7c/Y7lcJuOEQF196+CkxX4NI2KQjDd6ks4zsowNmI5Sbg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.28";
        hash = "sha512-2IOyVaqhV0Edysma1kD+TiWgOuCA0em1YOxDHWyyQmMASw4oBzSJqw2D60iiaHggzwXNjIOZdx9gEwLcCAIXHg==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.28";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.28";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.28/aspnetcore-runtime-8.0.28-linux-arm64.tar.gz";
        hash = "sha512-KM3vwT9BabY0jLMgO7udexcjxRPuROpS/LaqxcHnmGCZFBgVtSRRMg9McD7bixHWdSE+bAExOLqub4Cs6dk0dw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.28/aspnetcore-runtime-8.0.28-linux-x64.tar.gz";
        hash = "sha512-MFIQFySJXbwYvsqPqTnCkYVnj+9/sHmKK62Uh2HGHBcgRFADlTFfnyvXxzQ6FKnopDjluEHfOn3Dt3+qXCY71g==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.28/aspnetcore-runtime-8.0.28-osx-arm64.tar.gz";
        hash = "sha512-BPXIKaCiJtT5agQZsI04ar2Tu13+piisOF0Ms6yqDeBbI+N3YY2FRYhBns1CEGRRHoOb3keFNKGSyOVWONEuNQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.28/aspnetcore-runtime-8.0.28-osx-x64.tar.gz";
        hash = "sha512-DiFG2dzCmi1SIVPIxhfY94qmQWPLka+qcmoHeTZZmvplQNeL6ltQfPY5QIUHJLrcQ0aHP+AcN1MmZ/O6nqia9A==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.28";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.28/dotnet-runtime-8.0.28-linux-arm64.tar.gz";
        hash = "sha512-zM7kb0DGNYULVZakbxAVHVczeTwN9Gi0gDAq6SCNSGEO2hH/BBQiESbHRD3uagLgwz8YxVy59/ASf/LfEzlyjg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.28/dotnet-runtime-8.0.28-linux-x64.tar.gz";
        hash = "sha512-3j0G+9W9P/5BPnmIZ7vvJOIYuGPHoiTKf2PITgsoLFiPoFeakT024nbpNRayTz0y7fheu21hFS2/24uB6Nwc8Q==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.28/dotnet-runtime-8.0.28-osx-arm64.tar.gz";
        hash = "sha512-1xBOF48GxU0QGkE/OIunADF/6COcGn+VZbJrlv6OgTT96c0RPhkiBOLtT7YxLGZBIZEw8GWtVfEppCfBVUx+Ag==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.28/dotnet-runtime-8.0.28-osx-x64.tar.gz";
        hash = "sha512-2F6UrfZsDFFfX388E2ocgatoAT/+e1Uo5q/SPk9SfaWz3sI6/WloAn31sGTLJ0BPHUCuuT5bx41oLLcgDVKQSQ==";
      };
    };
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.128";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.128/dotnet-sdk-8.0.128-linux-arm64.tar.gz";
        hash = "sha512-XroHk3xTrvhEQPGeTdGbc3G9EQ9RnZVxUteSp+Nnhype0Obw//uC0D+IOz4V20Tnw9BN10Dxlm4nLSmEfVfw0w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.128/dotnet-sdk-8.0.128-linux-x64.tar.gz";
        hash = "sha512-Fx25ERhj+/CuMLnGF0WtXUVwbIKaJnh9pUvgA5R4Ks+yAV+vmi3cJRC/t8q+49i5qou7FEtgXNjkaSgZUMVUXw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.128/dotnet-sdk-8.0.128-osx-arm64.tar.gz";
        hash = "sha512-e85bCt5zeJtz48h5dLVkpMi3hyV4GjzLvY4gBIU8I+KzbIkfNKJ99uTCDvCi7ZQFcskceLoHwNXj6E8yVPGSdQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.128/dotnet-sdk-8.0.128-osx-x64.tar.gz";
        hash = "sha512-JxmGntbn0QAK4SAwaLVyJJbeF8I7GIW5GF3RG22XxaSNF8ILe6zKeNlKkj6T8LwdK/JRHlGADAFyxxyIV77lSQ==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk = sdk_8_0;

  sdk_8_0 = sdk_8_0_1xx;
}
