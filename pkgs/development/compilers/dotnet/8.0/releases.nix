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
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "8.0.28";
      hash = "sha512-tfvbfXBdiuP/Yoe9ey8aqbYlGC2IG4jwdwF7StHBS44eH17EY/sqJ3d2nI4khhqUCnd7qV7bjcjUEGWZeOpvhg==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "8.0.28";
      hash = "sha512-fkgB1szsmVKSZyXEUTX/ivz1fA6hTIoFKtw6zyR7w+X2XF0UeaWGhKGDJ5dDLn159Rpog5Du5E+vyKPOZzKl1g==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "8.0.28";
      hash = "sha512-uXtgW2a288+GuVWDaOpPXS/R1buQ2oNJ4WaKESNIU10tjf2Dt4/+zEaZTGvydqoUKGr4dS9M36aSmVRb8uPJIA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHost";
      version = "8.0.28";
      hash = "sha512-wznxCcpZY5NIRowg0xSs451gFbQ9kk7qe/iuGDxx0+uAY+ytwGCH1Wjt+PoduHbK25wpCscrxfvAHXrROb7vYQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostPolicy";
      version = "8.0.28";
      hash = "sha512-FYIF63kqDGvJtG6DU6dq51pl+4Pj794b5ce/KSqMhA2uQguzsgTrNaPTWipiTHsZ2L4K5YxWOlnwxHD3e2jDfA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostResolver";
      version = "8.0.28";
      hash = "sha512-O41o+gWp6iF7cVVdbrv0eJA6GjzR8z4Gejt9frGbIpf24m7tmoTBzzXlsM3favJ1nVxCGU6HI71PULVV+Flxvg==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "8.0.28";
      hash = "sha512-/Zdca6NfrLBISCkKiZdwoRH7fT6Xs8jIxTg7ADMAlLL6xW1PsLej0omE/a9JdqaXq3EK/I0OOa+yIlwqpt3tIw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.28";
      hash = "sha512-25Dq9XizzfIQjakKHnUXtXm3bCwmXUb/2VJOd9/SR02auZmpECEmjHWK8Z6bqJMUN6DlTJO40Ee+3NJo6TB8SA==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "8.0.28";
        hash = "sha512-zShoWaHL4wpKgFmKZejFYnVvRedwlnUlq+JcwUNQRg+wzc7YPG7tKNiOslaei27hXL0RrJR5xKfJYaMlqVGXpA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.28";
        hash = "sha512-dhcv0RCwuaFywQZi/kLYCBSfAtA3jlsL0+c9xzvytM0lg9oglZREi7alF5PVlTx06Gc6YAOAiCAG4z3kUwbsVg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.28";
        hash = "sha512-/vVAOipZdQGPuWi+QkA2vtBlR6XQqxbGjE666BiRl2QMdp5J++U3/W8H4X9JH344XSnjSSJkUP5sADHnvWpdkA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.28";
        hash = "sha512-R4Dc3I3ItUEUUNcbjM8QvrJSXq1p/SENQq7i4HQlA1yeaUS2FiAMYQqEqZGzrBf+zp0QFuD6l7dmGTja0jpLrQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.28";
        hash = "sha512-TumbcI2pi3asWkR1f0SZEmrM8PTi+2OI0xOu8oHbL5X3si+2FUfPisOi3pYLLO+Lr+Krcl/B0xJvDbw0/2AC1A==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "8.0.28";
        hash = "sha512-uTQDsYJAKLbyQ0ZNaa25vJnF/mD3tNbio3ETofrzSprT+oy3XjexuEbWmxLvIsxUgu+ksnItt+qDxV69VksgXg==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "8.0.28";
        hash = "sha512-BMeroJMXg0jpwv++zdDpMN1WrpdeRSLw1vORv0XgQy/MUyRvVtDLwUPM1Ey6XLIhrS9DHEm7m3NQNIeD+yiEmw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.28";
        hash = "sha512-K/e3Gex58QG0HvchtcrhRrt+78QDYbRJiecSvoUinK8GW3Da7ZZch06zJmq/aBp8pMvnP7Zl+iXo6AeNbm6YAQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "8.0.28";
        hash = "sha512-p+d573YMKwV/QDldTZTnH25bwfGSD1SUMQJgKjDlQbC1fREUG1Qfh7xtuTQWRDjwJhw2d+1hl0E0LPU8fGcRdQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.28";
        hash = "sha512-1ifJGyDircNlMkmhfcNminBMz0eYKVuNLmEQZ6phjY98pr33Alhq0LSR68ml+ByXZ/5Rc8kwM98hTGx0rA5WkQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.28";
        hash = "sha512-6WhlpxpTJcHEc56F8JVb+qTlQ5hC6b7cCu89zwwK11D8N7gEq5jCEY4dp4+jYmTik1Js8dTTL/+PnzlYB40v1g==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.28";
        hash = "sha512-buLh6isCZbpANdS7N2SsjH2TcVuL2Sd9q09Bd+HphBNjMEnsdkxsvSDUCScbVcF2pDzIwmbHzfVtQng4SRSK6A==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.28";
        hash = "sha512-Xng4I7/WzOualFuJ+wILMKJQG6A2mjKbxQvqCF1NEXO9K16Ee+3RApUS62LujZLRTAa9lYsQ89nMxy0QIkOSuA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.28";
        hash = "sha512-bIs5sUIwiWt/hfbxzXwrxnnhk5bGzWEf1GCSybGPp19Ip4h8vPZx3hvmkQmDz1HM82hGFIWwaqG3JKs5sRwqgg==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "8.0.28";
        hash = "sha512-uahroTICj+ms0lvN7pRpAcHQaDZeFWnGqACdmQb1Iii8ZWFJAx54mucv9Y+lPBr8UYcP3XRT91YVtmBeXabK1Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.28";
        hash = "sha512-9Ux/sT3Tedh5yLiywjhG923dTZlmBT1s5PFZW0nyItEFlIs9BUFgWhM0D1ZsRn2Dixt5vvZqcFTswfbdgNUH9A==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "8.0.28";
        hash = "sha512-YPiRx9y0mEOntQ/RUZRfR1hqVP8Rx3FQLbNlcO7N16N5+NZrQW+WHgUZ6i3EnJe5j4qB/ZH9elI9iszywKF0NQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.28";
        hash = "sha512-RK/nCYbI5ma9Bjrj9ROTb0kh/7fnzdqiMmZtJ65HWVMUOlj71zyVksvUJoHPKUWQMqcaJrsNc03ATRwKmDFRJw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "8.0.28";
        hash = "sha512-OkrZTnQ3qAVkYyLUmD9ykBrCe63w4ZiaNuq/1PN2n2kbrj3+drBlOynGN1/QrXVSWcaLOQe8HUBWMXFV/mtlng==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "8.0.28";
        hash = "sha512-5BfUKcpWItzL3wWUniSdxw9WToWJE7meOIvJTagAqcwCAoajVi+Kq9+Cp5kss8yIRLM/UQouKGeCzSAKNzoQQw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "8.0.28";
        hash = "sha512-weluW+ue4teD14+rOE8zTm2bppeYrv3wYh8o3WaOWSbgtZFY4lf5d8BT05+mBU3ipYKzBStZjEsnok0CReu5qg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "8.0.28";
        hash = "sha512-JvXCL2doNdGGVQPpqdO8TvqMyXulKXjmZRv7YC1T0TYOPNmltzANvQXD12oTFGo3bB86A8gLymeSCY39Reqm1A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.28";
        hash = "sha512-1O1IWEX2sDw0CytWI9APnBerYLakNnWbgDNogHg7usUW3PM5ZYLja3Dsqo93x95DhF6nCVyETNXp/ThIj30dFw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.28";
        hash = "sha512-zxA7hzeZ3ZRyBvUtyGhfyDxD8ExNXSBovXabZ8DJKHLfGtH3ADEr/KO6WssApy0Tzq2QVg07imwBVOa8qWcf3A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.28";
        hash = "sha512-Uy5F6rFIBTwy+JvTyrzLnrv3d4/GTBon+OGwKmWFe14CMu0XTv+6DgUoypywwCfzeiRnYopQ9GniUaaGixqYEA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.28";
        hash = "sha512-PHH/vMk6WXAzjzGM0vLNpZyKwaIauqmh2esCfGvaXfKKrCHZMrJ7nobJuZ0VAgmI3x3fKkNv/xDvro1ObE2w1g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "8.0.28";
        hash = "sha512-4h7lDu2B0gFxmdJYgg4kb3HcFkm82nhzq+HR6M/QjmDJh8dCc5DL31JuNi4itSlluAR/Ly8MHfY4cBQagmYQnw==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.28";
        hash = "sha512-JQCsYW+a9ioj2DxJtu1tm6U4SoQzPWv6RFMlIJbrZOds3cgp5ZtGcEH9A9Tz2UGhv0o3k4zL43gUxM5DsPyVbA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "8.0.28";
        hash = "sha512-I/bSGgkyEL/0zIV3nrBVvBrLh+XQMCuAhFnxaZxzUj5eLioa5uTiv/rs7IXfJOOQCwT7c5ZJ57w63/gW9JR8Hw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.28";
        hash = "sha512-DUFIs9EMHZrnaqwoE1+Io/Xne8c4IuqOv0Oarg2oE5IuDy7C/RJIsjwSJ4NiDFOPePc9g0M41xrp2sDVkeXtOg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.28";
        hash = "sha512-i+HQiCuf2U7BaG2KddDOZW+aD+jC03LP7lQvRvC2i7q8j9LkqRD4Do7j3a61QcPrNuP6eHFvqCBegfdZGFkGvw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.28";
        hash = "sha512-6OsjNiTt4Do/ZhWBz4ZIiZPl+i34alY1F1KS3hJh8InFqC5z9Jatx66Hzi4D27i5OUbfbObjxgupWFriMhYT/w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.28";
        hash = "sha512-T+WMJ++ffbOHwCKUZf60V0BKxnk6cBDOkK+pmeS/WcNakWNjuizRS5lFJMsoZqw2GGHX6cV7PVYYn8P6bwVjmQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.28";
        hash = "sha512-4+2QgXAa/3Y7A72Nma8nxbaoCLq6jtQ+/+WpscX6wmkRPbQikmvg8DpCc907bH/u1kA7YbLWJ3KjJ4CvF0upzQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "8.0.28";
        hash = "sha512-hs+3paU3S01TiCKC+ZMLqCDRTPPf8GJQ2NjFF5zMTEfITzEHKZmuczvIM90CWQ5OghWmDQbRyO3mGWa5bSjXyA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.28";
        hash = "sha512-yH0BFhF9hejIic1q/YpaxGeghjke12YdaYHyZiuTWAClduyJQ3JLnWFGYszZgsQQ9ShvbRfZrtGxTeccx5WOBA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "8.0.28";
        hash = "sha512-3udIveJ9Eylu95gKQuamP2f7pxi5SkObiNXa57QqkPoolet11Y0HtXG+ulbIxIAWEifC2bDagxh1IbXRWC2v7A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.28";
        hash = "sha512-LPN+nh23aQW406l3/s1OxK/yYPtfnAA5zEpDIxgdDGimY8YnrtWESqpD5t6+5ZgXwOlQN0ZMpjgDeJwD1RGOXg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.28";
        hash = "sha512-P7OqlVGb7QsgQD1hG3THM7iIOgx2uGwT3yM42MdrhjiiChzHCtivUhk8p1G4j0AszjaewQANjRr1RRzqGkKGKw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.28";
        hash = "sha512-MhiGj24wJZdsQk+jA0SCmF0Jk/o+cIbvk/8QcSaVoqiWszbsDwohtE4vqISw0fEVFp6De65/8XA+gmzT4fzRvQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.28";
        hash = "sha512-08plu6Q7W1/bss7J6Z3r9Ajlw6ptolyOm4XVlpuhIFA4GpE3HMGQb9xZx3c2y6f5IhugtukPetKK9BxvsaPV9Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.28";
        hash = "sha512-+srT08KG0BV0l7s27kxg4qsg8sPvsUtePGcIOtvXRbZbEgZvLEsY+Q7eRHpefSjrN+tsChw95D/HxvdJJVkh7w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "8.0.28";
        hash = "sha512-9wsw7+EsHRJGaMaM8GlCgicwP/Y8X8XQAPCKGF6CT/DRkg8UQ8KcHrk+vGEtChvWU1wVl0otlqywaJAKacSrYw==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "8.0.28";
        hash = "sha512-yfmfmdZXCZL/XpSUKMdbFO/0KPtVSwWbK6XGB8g4yPJk99rarbS0VbTZwAN3g5rErVkIawna4i7kuFeVGnP9SA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "8.0.28";
        hash = "sha512-GVRXtwnhvBfnqaUc0NPFUEw8J0nrRv6+N4YZskPWEDnRqoAqf/kR8CSmUTKFUaIno2FTfqq43Skz/r31Td9Y3A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "8.0.28";
        hash = "sha512-EgphooQziFlyFsSSFxE6syUBAaa8bAIIHETJ8PtsiSQTxQh1zWopYSFDpJ0oRTKikExL9Qmh8+efQCTP/Y8RxA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.28";
        hash = "sha512-apIoL9IE2NeyV0lCaGi+k3o62c0bG7VCOOdJYuWAO7Kpgvc3Bb44GQAB/Ukm6LI6d//YdKAd5CUQv7TG4m97Pw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.28";
        hash = "sha512-L199/3RzEAn1Qx3WwSYer0l6spS1+W+4wKRtWO+zAlice5eGjWoI7cXjYjhG+gYbH7xBUM/FSWjk1QcryPXKng==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.28";
        hash = "sha512-orKaZipoy3rzavq97O090V+c2HIYze8wsEbFX+fu9YO4FgI30zsrn3P+H0cSwN8Rm1YTbZLKL8lMJKr2wYu0GA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.28";
        hash = "sha512-PpK9ANycdOvvKyYhHdt9OK/SeA6RO/w/vvW6PqunhTXcndDLvvmxITMRm6xMw7Y22zSHlVSbfGVWUqeyvGiRVA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "8.0.28";
        hash = "sha512-6DgcFpvfmCJV+pVCMQvkfiies6RTg5SUIEkeRg8izN1FNSAwa6bZq8oToY0vrSkDWS4bmOkSJsjX63HobOd5kw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "8.0.28";
        hash = "sha512-oOmqXXKC/4fesBBfMX6or5RV/BlCRB09v8IUoNIfdmjWfyfu2euNBJKYhxrrtiPX6GVFErQH18Sjm6Illli9HA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "8.0.28";
        hash = "sha512-Lxe/UMtegABnawFpg//wXGME3oaKXg3SsUv70qpKsS0jJnF7hxTcGBMrewVvvtRX5XZ/VODQHEv8DSRzPK8eAA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.28";
        hash = "sha512-6B+k/JvX57ZcQPzgpjfXlFQ2BbY2B8KV8DZIUrbIj4agmCFXdIDGkIHLFFg34rSs1Ry4YKqb0fGooh3uuJAknQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.28";
        hash = "sha512-rpYOOZXHtFDHwybBUonlIyDD3Woi3DkxUlON9xGkvk5/fdbyAbOOpnHv+GBoET2r+xyfmu2+wKxqqEF1sLtztA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.28";
        hash = "sha512-/Tb5pa3bi8G+4JJq6SQLvx5olRbOhZ+aRgASDEtKEFbUbRL9ynK2p2ZRIw1PKarsRlBiiVS2mCWF29wwsgT/eA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.28";
        hash = "sha512-A+4WPF3lcmM+pOtsF+zbhNZ/+kFc614fSg4IiZZ+tzKTC3b4IgwcUqqF1nLuhEax7dt9mDyLfT68GdDUqz4S0Q==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "8.0.28";
        hash = "sha512-KM2PynT6zfUAJ0gXsWTH7GyxJMjVr6Qn2rvgazL2VX4jzzGGJbanW/GXyhPU7VP0miduWLTQaGpUPKRiHLiOiA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "8.0.28";
        hash = "sha512-n3ucgObQ84SGxnLHmrsDIuI+eDfpCHQE0qLdyuOYJZdbBG+TMEjTngf3cRQ/rylc8yMdFdiM4axku+Cg78wx1g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "8.0.28";
        hash = "sha512-OSWFuo+kXE+FKCcufzqYmVYhK4KkPipHuxyEZ3F098AC3bMR7g6pn8iSHXfthXMyBc5do7Ux7U1ZFXuwH7kCYQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.28";
        hash = "sha512-ek0PBlwkEJQb9Gdc9Jq2QWXWcyvm6/Ua1nezg0uvqBMrcR7zHv22iV1RiXircWfJfj8An82zI81mC0hEuzasVg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.28";
        hash = "sha512-UHWVz0akNhXRRigSXEEsP3FO3+rjkVoIUyPMLgyRCJy8oAMkc+4Dkc+vXYHI89WC7gwff7DRa20SOlPuKAt4pQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.28";
        hash = "sha512-nLuv2ZxxwCyszGyWJAFTt3xlKRYB2fK4t89cAJ8FTSFV1Aq0ElclgDewo+06Crgi5lEAsxtuOYJxv8TLrlC2Hg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.28";
        hash = "sha512-EpKZSr45kLpQRTSKJeDmmq5xtFbYGB3gsGnqZNPRlWwDyVtsb0mffgQ+iaNZPIfTYllfByGWYFwliRRbb9VhtQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "8.0.28";
        hash = "sha512-g7g+wahWh+Q4C/O3kSvJXUZ/ybz+7OVfmmbL6vurMfyUPEcyawU7sYU9FmOTC+o9RcO/DNOyKcG8oUqgvXr5Dg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.28";
        hash = "sha512-5vfIslziwBaRxgks/sCebdUSEaTeIiHweYXMs6KkAD4tNg9TIh5lPx1rTFP87EFeTmdsJ+zhgWeQ3f7jJO/ugA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "8.0.28";
        hash = "sha512-EseiduBfCyLEzvPGroRFfkLv2Py3htKIAyhUlhrzG9QE6ClAVbD7IAHUrcTC9jRTaRc+L2vObnHzZNj4NtejpA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.28";
        hash = "sha512-NVbh0p232jfnJhkYLzSxUP0SaG/CQU7NCo03HmpJ1axBvbYEHNm25bk/7MPZuWWWDXu1Lm2rXnEp+M38mZon4Q==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.28";
        hash = "sha512-BJLitmP8ZlTFycvuHcKBlSl6znPL+kjP/NwTS58ZlwiDg7Ru6FNr+ArxyCW/xkk1QrZi2XTbIervH6qDCgg0fQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.28";
        hash = "sha512-Gt5zsuuBt4VbvdfEN7e5yTg60oT9QYN2gGVgq0jPurkqLqtD0Td5ZljMX72/38D+c82Nl9apDeihy0pxIo2HVw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.28";
        hash = "sha512-Cye7p5WD90EHagDrxWLa8+AZ8M7dL/Z028g5KCcp2qr0/LmNKRH+gYBXC+jcOkFWoosJfRE7vEHZIWb6Do2A9Q==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.28";
        hash = "sha512-0dhW4EkQPwvgBJQAx/NFS8/ojyLv30Hr1Bk3d3z2Q3wxmvF2kGZdAQgb8EVsxo325vf0gW7j1KnOelOKtBadmQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "8.0.28";
        hash = "sha512-ltcivAhodRIwN58l6wy2Ig3Db+4k1wYXL2jj1fOfhxYzswoekZWtfWCb0f2bVCX1FYKpxSzIKGpvHg/YdDic8w==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.28";
        hash = "sha512-X+aEsykeX85ZjOZ84A3UxnZu3AP3EC+QTskYTxA4b7c/Y7lcJuOEQF196+CkxX4NI2KQjDd6ks4zsowNmI5Sbg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "8.0.28";
        hash = "sha512-GlabdJD2Ty+ZyXOTZzYPr765BoflPv9iKLQP13peWhCDgAxCw4t9w0uZ+nJlEUmV7sC8duj1q9Die0uIKvj7IA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.28";
        hash = "sha512-2IOyVaqhV0Edysma1kD+TiWgOuCA0em1YOxDHWyyQmMASw4oBzSJqw2D60iiaHggzwXNjIOZdx9gEwLcCAIXHg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.28";
        hash = "sha512-d5KUtzU9jk1d6jTM/yrlxSweXIey3gcPUiQh9qLSnL1N/dfS85QIq1uECPDZe/FJ2fklwQHmKX+b5EC4xwTMCQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.28";
        hash = "sha512-gRkiiiHCOMytoxN+kwRadI6f1u/p9GE+iKrnp7DeapUXA+OX6NEzBPu8u/t6fXb5tbvdAqPuKeoYbmvPLKF12w==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.28";
        hash = "sha512-cdbpEsRMQ8WmeKrz4Pz1uCaOa83R2Ei5FKYxK77PouJ2RZIBY7ceKMPyoopdJYBgjLeOsPJqNK3QbDW5vu5aTQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.28";
        hash = "sha512-UpNhuTIcLHk2QXO4Poo9vEtWI9cBG7tMPKU5PaF9+N5WoYs0k6crxj+HgjBiPHBRDBKFZILe2GTiJM4b+hYL1A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "8.0.28";
        hash = "sha512-uNbnG5gMwoCNPcsZQzcLcEBVh38PES7qlnEcqCbd/LbKZE7SB9sFYxOtBOWi6SXxJUYvhfh6vGt5Kim1/bMrcQ==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "8.0.28";
        hash = "sha512-GXTkWtzOUMeKZ+QukW1hAerGOgtWmM7/q/RNSnIxn+Xn7vkyFd9aFly+P+evI+JKD/OBPnF9hyXjmdGikfSXxw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "8.0.28";
        hash = "sha512-m+tLotKRrlz5jP+XZt3mLQ/HAR1WTFN8mq/PWSlBL4J8bRhj0L23GURgNGsBvpc3ZZxllyzugj2TNbdmv9tzSA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "8.0.28";
        hash = "sha512-PeaFD5MDG73Rdxo36l5h59HTE/A5D69B5X/q2l7TxHGlqVzi7lW9tPOfBbie0A9CXW7lfOEJ14JLMefOvD7lvw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.28";
        hash = "sha512-zYnP07m3k4EjSmEoxAlw9beVr2iORR/OygSxBuQDkaJhSOVLDynTgnZhJ9L0L4a6LHvwK1RQ0OtCbgTehCwD+A==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.28";
        hash = "sha512-iDN9OMl44TtB+ppL71m8Sjg2OKHPTV9jsX3MB2G01ynOBeItt1Sst4MOG39QTA6BXsQOCMrlZkRyCUhVrqjkWQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.28";
        hash = "sha512-zKZdihW9HSn1PpxCRvqmMeUtrHW9tiJdEXXRaGwF7CvSI81WKA+CkQzb5DmX/h1DZgwxYO/pZfpFu2lXcf5MSQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.28";
        hash = "sha512-eZRmxUa6Ohg7ep2DrbTcYpoq6Y6emN5F2XVimiVBs7Eze6Zn62D/KB8g8l0k2JKfWnx8gNiW7iSdbrkdJjD6GA==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "8.0.28";
        hash = "sha512-Uex6/8s52jeHAgeT01k6VKCAmf8YqrUb4D103LIZgyI9T4cZKyPj8ymWOkBt7bQP1EDwp1ctxJckvzaubjJvXA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "8.0.28";
        hash = "sha512-dfZD6+U82ONMWAZrVs1l4SgOFlA/aQM6RqSuoZbuiFLowJ5AW1r/2qQGjzThozADjsM0/79h28YsDNJohgI2Rg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "8.0.28";
        hash = "sha512-SRdQnoumUQkUjrO/IKeC9joscXGWFtxOxhImwiHfBCaRyiQCZSOX7G+NvrpY1HKaeDEdk3plYaXAM2U2Sa59zQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.28";
        hash = "sha512-ImEAIuRN6hAVX7Sfc/vamu+cRcnhFVLFkq/o5eVd12UiQpRYirhOxh6V+NlAYgP3gFwzjxBzxnMfJ/dZmA5PnA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.28";
        hash = "sha512-NTLPO9D6xBp3a1Hhf612Pu+bym3yu5kXvbYaCtG9D8+aHiwXmsOQ7EZaD7D9lUX066xmT+BqwTxrW/OaGXU40A==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.28";
        hash = "sha512-EXRu9DUg9w4218gU7qKrrXlj2E2blDY95P07ezThoaQPp5qQNOp4B3z2NLaMzcxvorJnjx8FZ4nNTeRDMJlOsQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.28";
        hash = "sha512-1NU9MHZ3QVuE0TZD68G0svZzbnXBSmoOtvUuLdQNNZyW4CbnftE255W/vveghpxNACQ8zuIXP9rh963cTYWp4w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "8.0.28";
        hash = "sha512-Bm86nCCWUfQkHq3y2B6GL+d9GoDNSy++dzjlq2viQ8IQhUIIelGqfc7EEW2SIeiOzHiV07ltlHCKT7lL31aFDQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "8.0.28";
        hash = "sha512-ShPOcQU4X/Ohyrug2d9+CQImXcN4G9O0xIl4SNFljo/CKOU8Jtw7DkN7IyTaiZQtXnAsm8hHVO6GRawneYF2Tw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "8.0.28";
        hash = "sha512-ERuvSwD5l04zaqSnQzTT4f4Mw4n3o63Ia1oEq88pkTcoz2SgN7qZDu3dc088PV84n6YnCknNGrP85eszVsvfOg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "8.0.28";
        hash = "sha512-xjEoTC4ACBnEk4g0tDhniQ81YWgmoca8S2qDaqesQQY/DibzXSnlllDYgP2QJ/eltVicLwvvoktnRbK0ckBNKQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.28";
        hash = "sha512-NJ82tbhnWoaj9S4ZEQWacJMqtLvA6DIA1+Satiww8yArAVd5M92beZJoRFGWhhLrE7jIg7Hc8vllCCwt9MKC+A==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "8.0.28";
        hash = "sha512-wBMCLPVsjmpYJ3+nOtVIqRd+Od4MORUMartONJrbZvr3NYsWHKDGyJwuOGSc1n2pW9BR1QtDxJNr3k6sNOGVTA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.28";
        hash = "sha512-1CkFb6mN/lygagk+LsEifEOkkUjRtVrWKv0MrtCQY7VeP5Pv3NPo9umw85SFMIgFsKfyGbObKOn5dX1ZH8wtVw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.28";
        hash = "sha512-uFKlPexjazbJRypFaLwDW/YfkqZKn0emQm91LhswkX3xj9LO9A580G7tKFpBmADdOGM1mnEiUbWHqFC32VvW0A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "8.0.28";
        hash = "sha512-Yp3T8ifEOhtEoIJ/VvNqCIDdaJMb3XrNFpu6Q2pnCY00v2G5qP7dW+vOr3p/xzXlnXjdJWQ5Sy5t1pYBDgSVjg==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.28";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.28";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.28/aspnetcore-runtime-8.0.28-linux-arm.tar.gz";
        hash = "sha512-zVEdL65n10TnH1xEn1tT6gCTsdd7yVnUzMMACo+gQgHhZ6laFo661V5u9EQDVP5DNtrSyF12oIC4JgWXwReoPg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.28/aspnetcore-runtime-8.0.28-linux-arm64.tar.gz";
        hash = "sha512-KM3vwT9BabY0jLMgO7udexcjxRPuROpS/LaqxcHnmGCZFBgVtSRRMg9McD7bixHWdSE+bAExOLqub4Cs6dk0dw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.28/aspnetcore-runtime-8.0.28-linux-x64.tar.gz";
        hash = "sha512-MFIQFySJXbwYvsqPqTnCkYVnj+9/sHmKK62Uh2HGHBcgRFADlTFfnyvXxzQ6FKnopDjluEHfOn3Dt3+qXCY71g==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.28/aspnetcore-runtime-8.0.28-linux-musl-arm.tar.gz";
        hash = "sha512-dEvWFYxb7/iI0/EWHYeW2zhfXrxoCy1LOnXeBZX1dD90F1sMo0hrZqA1ElcKG+V9f0PZo/x6ALdZPNfmICfa6A==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.28/aspnetcore-runtime-8.0.28-linux-musl-arm64.tar.gz";
        hash = "sha512-UfYi0fOfIAxI98c1QL9WMpjEcAIn2eMEfnnazni+MjKswJLAalDowyGCv5SjMo19PrnwD30LEfOsl+69ZwAPtg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.28/aspnetcore-runtime-8.0.28-linux-musl-x64.tar.gz";
        hash = "sha512-77mZji4IIflPyQc/JZJCELsJWc4/XQX7Uk3Wd5TcxukP0cfABU4J8bUXB3Adpu8hpPQJTZtL0/2R3Y61h6SMtQ==";
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
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.28/dotnet-runtime-8.0.28-linux-arm.tar.gz";
        hash = "sha512-99L2EbghYXzuxq+vHz186sim2y14T1pJs5VmpWhIG0Lw9DfO+i9vRLMTO0YHXEzA9aAUkv4YISla0ngWLsuBqA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.28/dotnet-runtime-8.0.28-linux-arm64.tar.gz";
        hash = "sha512-zM7kb0DGNYULVZakbxAVHVczeTwN9Gi0gDAq6SCNSGEO2hH/BBQiESbHRD3uagLgwz8YxVy59/ASf/LfEzlyjg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.28/dotnet-runtime-8.0.28-linux-x64.tar.gz";
        hash = "sha512-3j0G+9W9P/5BPnmIZ7vvJOIYuGPHoiTKf2PITgsoLFiPoFeakT024nbpNRayTz0y7fheu21hFS2/24uB6Nwc8Q==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.28/dotnet-runtime-8.0.28-linux-musl-arm.tar.gz";
        hash = "sha512-R815ng5QbcQARuFF+x1ZuMIUkfk1jTeit/zkzSqkRvAOZDiG9i6Lovfe1DnIBycEagSantMzUxvF4RmIMNeEnA==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.28/dotnet-runtime-8.0.28-linux-musl-arm64.tar.gz";
        hash = "sha512-Q3Tlm0ccR6WDwkE9Pec0CCT61rKBWP/NC1MZCjS/zH24Rv8qnzY+Wa0lf3M8avps7smcaxpVmEcS3D/sdCQOFA==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.28/dotnet-runtime-8.0.28-linux-musl-x64.tar.gz";
        hash = "sha512-b40z0MWYji55ApAz3BqQBsAPQjYfa/g5mr625RgQD72fKY5zq3bfm+sAg0oFZnMVye/4H2E38mCLnjmsoNpVwA==";
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

  sdk_8_0_4xx = buildNetSdk {
    version = "8.0.422";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.422/dotnet-sdk-8.0.422-linux-arm.tar.gz";
        hash = "sha512-sETXijwvXAPbW+rr5FzTBNgEmRA6PGspjfwOZjlBZP3Kxu3tgQBFhQWbW9eIuDlkgCp3Y3P/BDJ6dpe4YELIzg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.422/dotnet-sdk-8.0.422-linux-arm64.tar.gz";
        hash = "sha512-5ABi44bSy6uWfW55aoKHLXpPifYQYYI5sRXTOdCCVZ9tVI75CsE5cQuBfmiQy4aMhu9SaRWv3ywOgS/eNuQcsA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.422/dotnet-sdk-8.0.422-linux-x64.tar.gz";
        hash = "sha512-XN6Lcq2YuRCFYgehn2/7CXfx87msdrvQPtni8VU3Dit6lQ5YnTj1Wz/XeZoqvJzL5KOxgPH2KP5iVjSIhEngfA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.422/dotnet-sdk-8.0.422-linux-musl-arm.tar.gz";
        hash = "sha512-fVPuI8wm48s5LdEfWAa9v63NruvDS4yt6J4iGibPg3O+QVamUCjJs8yHQV3CWDxwrk/U2cxz+QnxXfUvnxqUJg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.422/dotnet-sdk-8.0.422-linux-musl-arm64.tar.gz";
        hash = "sha512-pNA268ps2UtJdeHu/bZpRxyOvuqo3FX8+HrNTYKslsr8wdOvjdC+b8LkYTv2VIScbCuAxrlSssu7mStiQmVZcQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.422/dotnet-sdk-8.0.422-linux-musl-x64.tar.gz";
        hash = "sha512-FuZdzjSWMcLuATEAhsFCxzPRawRG2yQ5j/It767XQP4KQRVLY0y6e3Uo5EcJcrbA6CNHmpNbMOVFVEnGPEoFKQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.422/dotnet-sdk-8.0.422-osx-arm64.tar.gz";
        hash = "sha512-yJDNCS5NcvefzHvjYfqBamxbJILIWsuAQIbho4apuLNZeM5j0baYT31Tmm5abODJ+cpmKGVxS2zn3e1xe4o3/w==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.422/dotnet-sdk-8.0.422-osx-x64.tar.gz";
        hash = "sha512-+wbSdVtAfOzk8qCtDDhp8oIgv1vnrmlUGjwihVzvActGPd4K92AAxEdUE0WiYe1ohH71kOS6eicQlEeu1ueVYA==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.128";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.128/dotnet-sdk-8.0.128-linux-arm.tar.gz";
        hash = "sha512-2zKucg0oBAj+Z4KPc6iXkZTLTSjHw4Kfe3WucIHaRtLFNlLFXvp9NBMVbIQnMUC0EGWjktt38WseQ3OmwAFFaQ==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.128/dotnet-sdk-8.0.128-linux-arm64.tar.gz";
        hash = "sha512-XroHk3xTrvhEQPGeTdGbc3G9EQ9RnZVxUteSp+Nnhype0Obw//uC0D+IOz4V20Tnw9BN10Dxlm4nLSmEfVfw0w==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.128/dotnet-sdk-8.0.128-linux-x64.tar.gz";
        hash = "sha512-Fx25ERhj+/CuMLnGF0WtXUVwbIKaJnh9pUvgA5R4Ks+yAV+vmi3cJRC/t8q+49i5qou7FEtgXNjkaSgZUMVUXw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.128/dotnet-sdk-8.0.128-linux-musl-arm.tar.gz";
        hash = "sha512-HW//XyyyhXg8+mG4DKvNOVAnae/1FpMZ/+T1rbyp4ND0xf4glzd5f4PslqdjLnBuXmkJkESDPIsp+nEGkcOnWg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.128/dotnet-sdk-8.0.128-linux-musl-arm64.tar.gz";
        hash = "sha512-eF2dIiJE1Q9wJPS3hp5OUlAr8IzDt9z9BJKutGKc6frYG+G3HfXDbXPcSpzJQgpvcKK6uuluGmtJ4wESX3oF1A==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.128/dotnet-sdk-8.0.128-linux-musl-x64.tar.gz";
        hash = "sha512-kkttmIS5ip4yi3rt634aLiwoG/56WoYChK/hIk5eTa7eHw1mNbjMQykV6kv9QwtbQHwqXAzEuy+0rRx5w6PXtg==";
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

  sdk_8_0 = sdk_8_0_4xx;
}
