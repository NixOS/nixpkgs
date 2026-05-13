{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v9.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.14";
      hash = "sha512-CCJBCE04eY1Vszgslg9Vnbs6ZS+YxTImTxx/0hNphQd3KUv9KqrTvtqXkjhfLIQK4aZ5yICCdvZhOGwbYAX07g==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.14";
        hash = "sha512-KfRzkAToFV4pgZuiLVXlyw4RbuGYsSAiAvZZQOno6Bv//zX1zTyJJiVcxlJ9fh92cDS8uJz+PaJ/ejhOHs5oWw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILAsm";
        version = "9.0.14";
        hash = "sha512-HwEHZLrgvrqc9GIQjcgg82bXj/m/czjG83IXMvg4y8qRsazVzJRwXn4f6pvR8Go4PTHADHN2odZ1RA7oR+o6QA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILDAsm";
        version = "9.0.14";
        hash = "sha512-gOGZh9SXiPP30Hq3jNNy6XyRHGy+imGddd+vITJiP0OO4B43YgBIzcaPytEzM3YPNeB9DHHZxgKenouAybqogQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.14";
        hash = "sha512-ZkmK4p9AZONSLNNWLuEiWYy8ynGD0r0Fv5m6biZ7oxF8GZNYfF3+YSf6+WQyRSxGlLtm2fEV96DqKJ3R7Jpzig==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.14";
        hash = "sha512-hIhDoJ1Je7kTlBjVaQEa8Ea2v9YNzHFpjTgHTuuE+uXw85mMA30+FU04rHd6ItX7i5oEYR2qfBSe2IvLtvsrZw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILAsm";
        version = "9.0.14";
        hash = "sha512-gR+yvtmxVFmAlwoFJ4wCyg991R3yLBacoOyIH+XnZYJdXy/L7a413nVGoqNpre09YT9MDlj8AVhp06elEI4ifA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILDAsm";
        version = "9.0.14";
        hash = "sha512-llH6vLel6SlPJuM7ujDqY9ZsPfkXglVlF1EozKPTdzVarxzfy3xbFnFxoUH0Ubl4KYIC7F22+SFA0gIX4lT7Qg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.14";
        hash = "sha512-cgIB1paNuwG20tY2h30OJrWH3f2XMGUTf3PH5qUEbM8Pnx/trvofuRhzCcmdiIMCw7uG0Z8fGusOslH2a2u++g==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.14";
        hash = "sha512-tl/iXIYlI4kpxftKdZkMzfS0iaXoFS3rZaLjf6n+nhOUPBR3iHfciHRCgClIFBIDkz03PMmSQYgJgfEmb1CIWw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILAsm";
        version = "9.0.14";
        hash = "sha512-l9EKeutIuK8ZYHfRLO4JNTgsCv9zwD7bNU27rkfkG00PJWzoIVutTGMLYf1OiYCKVJtawXQcfSgC74cYDDrPnQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILDAsm";
        version = "9.0.14";
        hash = "sha512-lkKYv2JhU5a6Ywil9qz2JBBBj8Qt8svswGIe0NG7BVi86vInbJAJWJZHBiwvG+3YmonYhbkEIPQ+xFWdONh8GA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.14";
        hash = "sha512-y0pwq9aOFOTXDT50ilQ1wuv3HTq5kc2QcMRBR2ag7pcZ/A+3egH8X93QxXMIhFU//oY0TVLVp8WITEB+zr7v4A==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.14";
        hash = "sha512-BS0EiLj7JtUJ7i9r63LNSqMIQwVbgvCbVgNDkA3vvhy97/BP1zS0R1hcF3AVZTEiF6TRpk/MRJmsNoYwS7bdZw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILAsm";
        version = "9.0.14";
        hash = "sha512-BXoutYs8qFdBSjtaRqrauyJZqS2CLI1NVuxtchwdg9aQxX9xG4Hc4POIqvFrZaRoVrcpxtGCSEbg6vvDWCJBrA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILDAsm";
        version = "9.0.14";
        hash = "sha512-KVeVExPnYZITgzP6Au2IaxTOES6vhIvhPOPPa7Z6DwsSu6Zd6t03HxM6JyU5/D2nKofjBnvcPjKW+zS6gA5zCg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.14";
        hash = "sha512-ltQrtUR4/z8hmlSSkV2dU0rBHmAIWNmKmpetNqTJY233SeVjbgieza3EAS8tYMhJHXAGaqjk84Em8qPaemefDA==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.14";
        hash = "sha512-vKjaQVMP39vBz3CkOpJILVyz+ActsFe0yEvmDOa1EXdR6aCUkpfq89icnlSFWr/oicz9hxGK/cOQgSnRXM2T8Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.14";
        hash = "sha512-AmLrJ5tBEwPK1VMPdk4Vy3Z6++yGkaL5bpKwGpY9SUL8x6nwQjWfY87snOK99X8NEXltxJNovP0FkRLCi+Zr2g==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.14";
        hash = "sha512-jYd+5KNUzdo36ytc1Lz4TlAeHhRNMXQr3cdBzYAqCx9wfsOUnqPM24nx7XNvNryawyjPicbdP2wiNBgdQlts7A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.14";
        hash = "sha512-f7N/o6P9rxLrfKJyyy7pp/7ytpe+CNa9LdyWPjYBSTiVi9bIPq1yXK6MM4PewCkLsoS0jOOEWmfYHrYb5Fw7VA==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.14";
        hash = "sha512-Nxre0GsAxbGLmlfymqMYsWps0rexVTEyKyCtv4SZs+OnRd16xd3YFoxuqwaqKOSGuDPRIX9yJF/POjWnanA0HQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.14";
        hash = "sha512-1j/Sem8h5XELOfV/8mnVdXuYcltI0JXAyvzNeC7uBJlH/ic1HZ00TQlWsv0/WIgnHgSTAgNaa1HxnAYL35NITQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.14";
        hash = "sha512-DPYynWbPeB1oLDtUxOQLu5SzJQlqQzG01mxGoD1qTjDK1V1a1eVWfKMRZ56tKkIS40zywn8ku7Rpmrf4F4v1CA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.14";
        hash = "sha512-2mjykmXgsvwZb6qItFVw5uTNlGE30SdjSbTaDzwElYIo0ZFJHKYMuQsBxJD1GUzets0n+g0Z/dZ+MjddeYI5Vg==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.14";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.14";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.14/aspnetcore-runtime-9.0.14-linux-arm64.tar.gz";
        hash = "sha512-xc0FlxycugwhHOtV4ibL+2LxctuDRfpdTkdqTMs6T2HW5R3CstF461XzZzrS1hz3KuZJ+4TM8sPbu9Ss27eBMg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.14/aspnetcore-runtime-9.0.14-linux-x64.tar.gz";
        hash = "sha512-bQlHOQ+ewxYpfyGp7AIlKKJyBaRDKPlBf7hnV4PtxWAi5eFeplZQxec8tzkXwJxSMF0+heTBKs1eEQdIcbsGeQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.14/aspnetcore-runtime-9.0.14-osx-arm64.tar.gz";
        hash = "sha512-VhV7qrlOtSivrPkhaX1mPrID4RS+mOCKAxUwPQm4+F9y8dGT7tpx5Mg/Tl38hRffUoq4ZJ0XVIt7YTaruvfr/w==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.14/aspnetcore-runtime-9.0.14-osx-x64.tar.gz";
        hash = "sha512-Ts72neYQT0t8dKvHeXCeSAVRF/3KZORdCUYaoRmCpEmOoXW+z6g/fSrZrbiWyYUXAhSOdAPr7ifrAfFTWcqv5A==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.14";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.14/dotnet-runtime-9.0.14-linux-arm64.tar.gz";
        hash = "sha512-D+DekyKzozyyMlbOZJ/lqUlNtUdsUO8lM4bXTp43Ipk87jh9aFAGETGti3fxRUj6E/dyyUhsMq6jzQjjE/dvcg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.14/dotnet-runtime-9.0.14-linux-x64.tar.gz";
        hash = "sha512-2w2wuecJ/+Rj3q2U+053ubDHCGu6p4p4qmtTZr73e6PDOJmoHDwa7zwRAnoebN6/SnrTBTK9wZPw3sxxly5d2g==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.14/dotnet-runtime-9.0.14-osx-arm64.tar.gz";
        hash = "sha512-I+bbmZG+jlrTsGD0/oKGAXa/Qx+zSR2f1lZyWTvQBLqshg1JuoOozYRHZqcUGwcMj6jQyKXQ+mi5uNFTsKk72g==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.14/dotnet-runtime-9.0.14-osx-x64.tar.gz";
        hash = "sha512-fvOeVkit9BLU5WTwgIFh2X7nBzG7GSGyZiltM+1BgjGjGP87CRM/PaCloYkn+VE8g/dN5e2cMMfGb1jXfuh0jw==";
      };
    };
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.115";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.115/dotnet-sdk-9.0.115-linux-arm64.tar.gz";
        hash = "sha512-zJhNLUXOnu0k3Xih2SG0GbgRMZJ66RC6UL0oCfZMxADGUlJAJwUyopA6VPWQjEWAmGTMNUZVqLpEUBcmN9z+cg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.115/dotnet-sdk-9.0.115-linux-x64.tar.gz";
        hash = "sha512-g38je4D8WM3Jf4AVTHz+UFpzKNyTxUFAZwdhBVq1bUHaEfhiDlAKpAVXhqfuCxOLW3Nga0vOThLIYBukJtOtgw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.115/dotnet-sdk-9.0.115-osx-arm64.tar.gz";
        hash = "sha512-eU+QDeVY8w8uI3WWXAjADdSZCq0p4xv9CTsIsdmlv1fHjMbz22jNhTB2+BaJKJjEPVCOeES0BguKkR3Om8x3Xg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.115/dotnet-sdk-9.0.115-osx-x64.tar.gz";
        hash = "sha512-J9XlO62e6j2yJSK/w89mE8GPuPHdW4INzZe5fb+NZfLz6sc8Bh3OkTB5mhWU0fKZW2+Jf8hS+3F/52s4ea9QFw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk = sdk_9_0;

  sdk_9_0 = sdk_9_0_1xx;
}
