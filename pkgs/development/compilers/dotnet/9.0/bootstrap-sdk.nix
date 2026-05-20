{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v9.0 (maintenance)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.15";
      hash = "sha512-0ITcaDR4iWo44bInmEy0a3rUmyEaDfP50h3a8y3ZTWAy87IQo6PhOj543ekhxVRbIHZzfUaqWThy0n5jrZG76w==";
    })
  ];

  hostPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.15";
        hash = "sha512-78j6OO1RyiRcFGaioklJQ9u/q0VBMIQDjrf1rkx6et8TYQDPLi6baokGktWzMNHh1sXLdO8Vsn1kfysNoobpVg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILAsm";
        version = "9.0.15";
        hash = "sha512-ylv3Bh0cSVqiNILeV25pcuONtSjqXS7bN/ijLkGg84ZStOWSwDpm0kVa63cOwBiDEnS7iUa8r3AguC2oRIA/Zg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.ILDAsm";
        version = "9.0.15";
        hash = "sha512-2gsanuISAXH7MPYz8VrGolV87nA0dTZSXjBgpT7wVsxOOLNjqfmODvpw1VZru3bk+z380aOdRlijU4pClHTbJQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.15";
        hash = "sha512-kuIy1bHzIdYe6pta/LPMpH5hni4btriPViGWeXG3oqr0hmpLNbjESbGW8h285W7XqXNFIxtt62fiAPonAN7QjA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.15";
        hash = "sha512-UOydeXToh8qXtenjBkUVxMn7+4bnWLUrPfzMPpHdlinkzbKNEKw9XTdncr6o5KLTKnkRLvtrCND0JXdaSV4JJg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILAsm";
        version = "9.0.15";
        hash = "sha512-J0vUOuGhhTC01vFEIOeIZy1P/f1I+hU8ZS/JmwLAUiYDx5jNbAizhsT02Z3SAfM7PGn023glRfWml0J43EdYkQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.ILDAsm";
        version = "9.0.15";
        hash = "sha512-irnu6y4H+K/4HpoV95KjvD9fIJyAh0gPLcuzQ7V970459yG3CnVNKxk1R3Bjm+lT4xAqF4GZ2WzZLhszig9Gvw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.15";
        hash = "sha512-HGSeAhDQn5rMeJZB+lbacgE1qo0oYyt+nF2ND6PBcpiIK3RZs57VI30kbhLXN3HRlzqlWwmJquDRSKO/BbHbDQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.15";
        hash = "sha512-HwNqX2qYcymE22qFpp/R+1EYMw94qbVVJl6WL19TcdLmWDzZs0acP/O+jGQX9+LSZ1vY+LEfYUFIu51W1xu/Bg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILAsm";
        version = "9.0.15";
        hash = "sha512-swVccyR4m0ozLI+sSHw61/f/2YROkPnyII4ymHtDNsBxugmDQGOGOcd+y5vU6Y2Ocaovkc5aJiyfncECg/+YPQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.ILDAsm";
        version = "9.0.15";
        hash = "sha512-2jrawLdyco2r2wlym4lwkQ3QGja0PpZz3tjIf6o8wwEig1n4XKkLa0Th4RxX/X1/PDx8WlyrC9Mr8tcQInWAig==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.15";
        hash = "sha512-ouERhZLL3tyv9PCSa1Ffi3CFRFusaXlikyBev7wv7mcYSA+xdlVaWk85n10reyRXN2tKJIFRS6k10aOKWUbnFA==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.15";
        hash = "sha512-3fBu+ZuxeT6gOiLKm2YJWzbuclGH2089ePrvKQxxb7hvqN8mMO+G3lfMGqA9v8aLE2GNWp+MDuEiyu+m5qdhOg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILAsm";
        version = "9.0.15";
        hash = "sha512-rcikImxoHDbwjnHu23HIFa6BG9Awgj3qjRBSQgmicJBZudd9eJmoKflkWtTFCpYvQvP5fKYowWx2bshhjNJo1w==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.ILDAsm";
        version = "9.0.15";
        hash = "sha512-ecF6MKQBpR4cCw0GqQm2KSXRH/XO/Qn8HZ0ucRbRpI00hHMhBQEviC9nvi6P7dkWp7vgLtty+NE6NAbliZ7LDQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.15";
        hash = "sha512-2JWrZHSBp/756CizUZrj9IZw0Uznh7JzUNnDfHYWp66dTmFcgILSW0IaT0qX9sR0cM3Zczsbxa2+vRlW21Ff/g==";
      })
    ];
  };

  targetPackages = {
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.15";
        hash = "sha512-fWtSGeIixxjpsLj1TheWKnGGVLC2VLRuHCFV2YRP1smNWAz+pjcJGkw0CnHG4Due7kEJGe8aDBrBbroNDLYsLg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.15";
        hash = "sha512-vZiZin69Jx7+GwxDvxtsZBiqd3FVX/SCXiRsJzGwKdRoJBUw6XGNPq+EngCdZA9+5leoGvGuvXGkvMNG1l3RCQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.15";
        hash = "sha512-piCf0clvjiWZR5rnFT1w/Lt8GQNu45CL+mYCOvVjtryfKEK2CO2MzwT6bh34sJBVdnrT6SJgxjvBkE0gDPNxTw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.15";
        hash = "sha512-HFR98+ws9Ag7mNcoJY0k9EsczEKJMiykvIp2fFH3xR54tc2oe3KhU43+T/83R/o2XWUeN9UpXdKnrG+cn60FKQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.15";
        hash = "sha512-f1xq/KbX5Ba1ujCjkZe5EnkSCnRTgEJEKVQTDH4ZUkRL2A62SqsD/rF5u+JcLVUSgIAnZUPBYIeAFeIRJyCQ8g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.15";
        hash = "sha512-6g4QI9yu1Tb4bDiXY3bkIlIidNo6Mp69Of21zFSSUy0dRYDT2kuNSjDgkr87sAQ0exqFYWRwZf+oBfNMj3gkcg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.15";
        hash = "sha512-iaLUHu7zxURFwxJY1QgJCtOJaRVQ3kE5iIP9e9+FEX6Eum9TQpz+FISQrKlLsgKZIloC/QLL+JeVOnqRAYelLA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.15";
        hash = "sha512-by2spvXuAVK7hMzwRlrzDEQp6u/xsGk1pat1Bg/ZSFeNsGdOUDV2M4JDGp5r35YVVeaEkqwu45D5zeoQnjTP+A==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.15";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.15";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.15/aspnetcore-runtime-9.0.15-linux-arm64.tar.gz";
        hash = "sha512-crn0sGSeWjuHRZfBtQ27skaDHpM0VbvjTDxT/90wFuyn1CCQxteFu52ueLnzTTd1ffK0MPYwnYEcCN9oOc4Azw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.15/aspnetcore-runtime-9.0.15-linux-x64.tar.gz";
        hash = "sha512-hdR0swP7jxhnEl2aoew521r/8XmxZSh+Rf14t+xR1BTlk3hxvaWUi451Cv6cIgr+YTjrpxCAkL+6Hl2tk9OcTg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.15/aspnetcore-runtime-9.0.15-osx-arm64.tar.gz";
        hash = "sha512-xEHHwAQpEHaMhyCXP6lGc7SAOqXABNp0W+QYBeT42PSYu7ddbGC+7QuFHaGJsRJBqUvd//NE5WsYMaI4an4hMg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/9.0.15/aspnetcore-runtime-9.0.15-osx-x64.tar.gz";
        hash = "sha512-I5uYew1gididOkB1mlFfnD3YAYklekxowKIiKFHcvDRC5o2w3yFneX2EUmk+UeqRBSmImLfQvIIGmxoyscyArw==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.15";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.15/dotnet-runtime-9.0.15-linux-arm64.tar.gz";
        hash = "sha512-hMDs9fd2WSjMhv6UeWNCdvFgk7nOsgHioX99/lVVXZCVgSBOY0d1lGjEl6zQs/uFd5fhRKLn8brFa7/qTVrIyQ==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.15/dotnet-runtime-9.0.15-linux-x64.tar.gz";
        hash = "sha512-5lsJk1eeCvpwnNwo9vWuElJDfCy9L9zEtDboW7vOcAID/xVWPimF9SjxdZxDhlypQhcTnTbWpi4bUpa9mi5AUw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.15/dotnet-runtime-9.0.15-osx-arm64.tar.gz";
        hash = "sha512-KLa2tkJvx2KvgSIv/pXQ82uQdQBwsN8b+yXlSKnQsEwGqpcuSF8nra8Bo0hXoy5zYCSUv8L0Hk1sIIld0lKrug==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/9.0.15/dotnet-runtime-9.0.15-osx-x64.tar.gz";
        hash = "sha512-XYvUzNBpo+nLJ+0cRyrfaGsG0ekgFY8ovbLSjgM1PM37lzcEoa6Aege4DooM1yRUmpqtT3p4xqgGeoLPhwWhQg==";
      };
    };
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.116";
    srcs = {
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.116/dotnet-sdk-9.0.116-linux-arm64.tar.gz";
        hash = "sha512-BdA9L6RCnwtIO1+J1FVLjdWBd0lQBVJFWy26Cz+0ICeZrPZJa02tZtJxq9PRjD+MLw1yHCnGN042ou2zaEKZaA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.116/dotnet-sdk-9.0.116-linux-x64.tar.gz";
        hash = "sha512-pBBcDHcZ8ymeqCKZlnyGauZVXgKWlp7dll7NyL3403dR0f5usw5FfOFxHmljuXhkOIHiN6W2/ZlQvCALO0892g==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.116/dotnet-sdk-9.0.116-osx-arm64.tar.gz";
        hash = "sha512-3itAGFEqEamTQmXwawAWOXpXBDTq6rPphZgCxn9SZi8bhohSS4X0S83uIhk1J/ECBb2XOlj1GgEuXEqEpOLm/Q==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/9.0.116/dotnet-sdk-9.0.116-osx-x64.tar.gz";
        hash = "sha512-6tfZS+xXXbYiGA2pMBdWerhYuWd+93sLvKSHhkeI+yu0XVNMNN63ChRHZDD5Pm4kAZeux0zUMQw6JQFUpgAMDg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk = sdk_9_0;

  sdk_9_0 = sdk_9_0_1xx;
}
