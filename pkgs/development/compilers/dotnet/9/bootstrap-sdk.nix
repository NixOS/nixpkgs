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
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "9.0.0-rc.2.24474.3";
      hash = "sha512-VYoUXb/87RzxdErwwqfVb8WJLl+7YL4PBxI8QY9cer25Zg85yOUxaPHLnX45QgveH1iNcEHyEr7vJW52LkyYZQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "9.0.0-rc.2.24473.5";
      hash = "sha512-va/LQIocBU7wyw4EXStwGTdHnrcyBSBVuRaRlNd3I2IZrFZ5QhRSEKwW2jFvSYWowt2P4nL4e/YvweFnWs8DiQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "9.0.0-rc.2.24473.5";
      hash = "sha512-tJYYbEootDwmS23jQtXRN/HrkN57sLdcpjYuKjqzgOsWVhVYr+5Yq5vcuYa03RiRv/PnoOmWB6pMhQ69qfIhcA==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "9.0.0-rc.2.24473.5";
      hash = "sha512-7gm4DUCtrapDZxO1aKiPGm/danAxKvGiCyj16+4zdgD69S0UJ0mwQw5Mn7xIhrz3/YSC/yK7ihvZ4oqc4I00aQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "9.0.0-rc.2.24473.5";
      hash = "sha512-h08RQolDzXy4ihvbyEb0E75pozEG/tyZgPaKEfWGtEM1Byvbe4SDrQlu0G4f97h5I49L6Czy+RQ+rdnyL/XwjQ==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-a0w9cqInj6szGJ+gdJsOendvS4xW2ZiXsYXRfPBHexbwYec2bFD/wFcuoPQ3n87XSdnyUk6cv3w7Njcb/wU1ew==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-9QO5gJi33NuIawkG0H7LlE9yeHtDABCLniQzsf21x6qKBI1DtGlVPEEq05mHW4NxkV6DQlDjycifukN8UY5GzQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-aQZ+KhAuSb8x2DvsFJwvZTCkmyPvd/pu2XU4uVHuaRQ2A9wejpdCTtXeOETWkZBR42qBXmzoZiMO4JnlmwDjGA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-SCiUPToHRHRVcUVV0GbyKj7kENAEKfhrdlZgPxwQNxbBHbTpg+pUtwdmZHXd4ALEx7yUYKH+gZ0NgvaxnnkA1w==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-V5hJqjyfqdo6JH0n30SZ85vdsw2ZkTeFen+N4B7Oh93PCK7GNOvW9FsjI1VPoIvygjOoPek5fQMyj6hKXbzYKQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-dYeGj3yq0iyv0ynhzCnzYPTX6NzOzarCR7KJp4TvIRmAIRzQNyR3wmajXCcmA+zbxopVvPuWdV6vE2TR2gJTug==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-H8XU5iqkZLCJYnI3BoQFSipnD4np8QV6UgG9aoF1OU7ePQ3QLbqwIrWdk2SISXJGyRWwtcZCmw0DkGU283y3Fw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-wj9IJOdrWrBcDC9edJtjIkItXcd62C/Izhq1jS1IvqBWeUSekwtKBvBxVEeKrVrSI2gdabcnUqzZDo8mF0UemQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-Gu5AC44xJKFxLVBtQm+/aK8aXeTJadqwNlG0RiJe26u+kzZps7SU/WgCWSi5JQeMdS5tN4xOq2mDbNMx1Euzpw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-nDxzSmkIR8M33A40nE3t7Ocokyr7kwjE/20HDix5/jSqDrVXkuwrpE0RAbxlqV5m2SsQ/46vnGj8pv/z6pTfpg==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-eGaMRTh44mmuFIsExzJmPoNk6FgM3pMsHXXcZK5x3yfj+s5Q8GiW+uQsPQvvEI/vAxqQXecaWpHNSsl95s1HCw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-94YWNVgdISC20qj+68bRSiG53bCoH0xz3LMdHPm3hl1kU0sXYIJV3m4H1MHvTIMWaDFQMChEACeTfQ4lmFe33A==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-gy6X1t3U0o4TaLq95HG7+KYm1OJc3GPQBYI887/H/is64cR2uMb+05vKKWO/LWpjjk3R2G6AxIh7yIor/LrV3g==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-XlvuVxf0NHsLBNTALgTTaUgP0gdjayrZJ/5fIcY/WjfxBS/k4LTYtEPCrWHHgfSwQRtf88zxy68wU0YYNqmnOg==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-uZPRPhjW7mFUVrgNo9bkD7IV/mi51JhN+tmctCClPbMvojpwwBCwRVHm+FZvuRGnohEmhulP+437gWfebKHD4Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-1kJfPoFkc1h1vLn8eXVYWDxGnLZgcU2QoQ+SL1FxMiUDz9jpgjS/ED5Lue28S1eqEvORhsq0hCPb5rd+hrqAJw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-Qf8fsjuJicTADESM1q7jb/2mmd2wfz4UJwOaYm0LF3cbfxJeJ1R4Nz573lDvyzG5EpZvhqgdbIvi+Js9yPvR+w==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-uM+ZHRZaPZF9/9mPB+B1r9+p+ejsJWrZeAmS++441xiTI2WcnacgOCASqA3PaBceGHHAbWdICPJtkM8zb6cu6g==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-6oqxcjiVqyYQ2epUGRbWD3SFA+crSFp5htpAQPyBFN6WQCj0vuwvM15RhSTqb1J1weQ3Y4nq6sEI9FMuULbF+A==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "9.0.0-rc.2.24474.3";
        hash = "sha512-9hLr5fWmk2ePIVEPV2Jf1BdERtIuoAm3hTs78cBAee2BMwTlFjJCBVxpCIIlIGRG2SA5iJGm5PlBg+IXe/e7Fg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-hYVPnToTQZtSZyafuFYAkvGQCkoNhjyyhbedOhNQQbKaT+OpTHEwRI78DG+E+n7+pKU2uGqzVErP79K66Dhvaw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-dvFWAmiDhmOLa7yA9uMpXOWPG+S3+OQ3uv/u8kk6EsFnjI+GqpauqwghGVamf5Sf9jMXViNJ3I3cGuGKbtQ3eQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-jnnJ7m79tcpT0KyMD5FA9Hvcju7PqO8VrtDSkrhCydJKq6f1j2tQukH4L5bx4bxdH6L7AbtZU1W6a2tOjWavjA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "9.0.0-rc.2.24474.3";
        hash = "sha512-8P8kT37mZIlcBLFJ+ybg3IEYl0LwYxa1EHCJmqiI7BGsEMc7Bmo9V1Qu04rbXtsltQroWC5OeIb6UkvM3Q7L/g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-ittiMXCbVOvfF3Wx3wUVeRRGYkr9c4gVhFWWKNl4ESCigotKCym6/wuZ4Yh7q1CmHOzorxuuKWeW59qL6+Dmnw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-u4ST10PMetmuDLzRIrQrG4G22zKJDjTbQjHfg8GvAVrGorWb8XjeuBDRcAggo72LzqeI5O6rVyLGARoe4ozQTA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-I4kfngubXUj0Z/2PedYhOuS7MdcgVeymGS9BSLAVwZkjxJq21YxK3B+VWqPPtjvn5CnNTx1PKWbchd8HbZ/u7g==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "9.0.0-rc.2.24474.3";
        hash = "sha512-lFkrconTLamWAmhwMmFGHlFVvznCfXUYAxj1UUEcAzRd2B09iX5+mJL7OdZSatJO+FwJEdLy4DJL3w/nOY344A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-x+r8ICKAP4sAZrG5eSUg1wqb5XCaSusaa8v4RtAWF3lYrlnRHPMtK4K9BUgr9D8M8Gwiy8swVXTcd95NggIJaQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-1Bz9FeS67p5Rc1h+H54fMfSb6l8uhpx1c4pdjTnU3DwVWZ+e3UE8cGi9Vj0ICDmClvKWx8WvcbkWr3yEFn6Oiw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-EBQcA5874itepp6PYbW9kXKl6JBL9dtNTpDWyCWOv6iUZgt+coVbOVHEbBFh3keqMB5J9P1G61AW4E8TJANvIA==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "9.0.0-rc.2.24474.3";
        hash = "sha512-Chm/DOH8nmg/bL/OAMWcfSAT/7c5W/DW5909fpNgCRHJhztTrT61AhmDCV7Sbj9aCwp7H92lZW1Ov+jtKtJWvw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-NbqCc0FaVX/rhUe0TYnMBNjL3fqnptO6bdSfjlpjP5cfOV5c7vNcwhwl3IY3a82pFUblXOT5Ltw1s9meRlRHeQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-i7inuXamQxuvqTbjO7Ex3BWN1lambOO9LRhgomSxiRbmRj/vnArzlrIZo3XLcK+j4pvWFatzLeJ9iGSj1e3vwA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-J0fbjcCjNNxSHgGuxaV2900dDskw9YkcmHNPx3TRrj68lkrGHdOd5ArzahOGAkUT/zlrklwMFFAWfSgpl5j8TQ==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "9.0.0-rc.2.24474.3";
        hash = "sha512-wCBrrChR7n5Lz9FvHLoCcZ8/bMBjEK35Oy5EEsKqrrLp3NM9IhPeklNnEQF5lm05i9u8fx+24faoH9bA8Eucnw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-3d3UJgKT9fT8WEceC8h8iAz3kwPIJXYNfSQykPYShUr3bpbt2lWS8Vz9eWSB2Quadi6fyMX9w4M6bDsChMO1Mw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-gVEHwf9wUNgxS2C/jd0f4xHZYHmRAmUB1A1tY1RL0fpphw/6p7ytXsQ89eh2sG1SquhznZhPPblEBfOGcs5mtw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-hUok62DuWaFEtEtQCHnOaA+T1F4IhS6DxMdJDgCF/PQ5lQlPy4T2FyYg7VFDWQbM2xm0BhD/Dc9X4fvDJDW0sw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "9.0.0-rc.2.24474.3";
        hash = "sha512-OQoLmTaSSDEOE5AyaMaxcPyZan0jl0sBYqzL0VKX03hrDW5TU6TRwhV3IWLuMHw88+JammuRX6V8PGEL2KL0aw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-EUSs0bkXWUk9Me7Lo9ZCF4Ellid9cPKQbXv4l2+378I5pgJzL9vuz4orzyfO5W26drSXknU/zm0BEAOJU3pAmg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-3pVBqaNKhDhsAdJSd6V40vdHcQ0jZ1bH+AEWkm840yskYN1AIqA8sfFPiOdWLZnblbHG7P7Y+l25hhx4/mg0IQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-n9svtainSSp0E+pHYxg6me3qXTT0vY89OmdLFLRP1PW2/iJYUx65If9J1NzOsoBy6wnrTpiSbmODYuS5YGfU3w==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "9.0.0-rc.2.24474.3";
        hash = "sha512-60vE1xNjUGDvGaFFyaQGAX/uboU0dG9/VU+3GbX1120S2o/WvNM5VW3zXR2yBnhjcK2kpgg6DMvOrl0MEZtBUQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-yJgKcAx5jtS0oFtIklA6H4OwDSFEhsJaorGyrIAui+z/tTl81y7i9jy3kgSMQ34dJUflZ6QwpGdUn1GAh/vfng==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-a9aDzwnog+KG4OXmxW1//6k2VNrqbNjiYxLSqp5P3DLZyY+1t4+rT4XiMt10haxouEECDQwOM52LAcjBhKhZwg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-sGYv1THJ2s16u0s+zcavMFEj+VGjPI+CYmUqM9MnUW3SRHsMyKkCj+Iy25HAmmTNLv/q3hqF/URE/rWdJvJkhQ==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "9.0.0-rc.2.24474.3";
        hash = "sha512-cK0x+Lxe3lEylQnijK9K/I9o6p4yHYI9qtrSMRAqSCoUxaRoBFLHwljaumRvCyejqRCMmYosda7z9S2rDxjBXA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-WTctjwwzqXX0zDxVkFlK4k+bhEDAUzMv1/5ikvqhfVF8uNQUHnZFTx9sXTN0msVJ5FHWuNIKrD1k06YhvVuV5A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-0LUUXfBkZ2S/5GgCl3gEPbh+fyJOipdcnyYkOKrCwZn68fMHY247FFLKthdauXsEOU5RWV4PQbjELvwD543rGA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-Kx+gvcTQmO9X35eSE9z7vOlrG2J2FFC3Uv6zOXoCtJugJqW74S6AbUP8JRMnZCNzv2cNnEK6xswyDg1Mf34sTw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "9.0.0-rc.2.24474.3";
        hash = "sha512-2ByJFpaf+Dm+saB+NniupfwHJVbCNuaLNX+K4pH7Bz6dUYXlcWh1ja3l6G80PYJRNziyJY8fNsLhNFBnSCA39A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-tKSRJQ4E/PndHyAEKnDitBvgTnJCtzIBiw4MAim7mmdO3T3xCq3N1PP/WRST+JEMDy19tkLwClR3SqziiXPAag==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-gNMyW8t/1pBYNWwZpW7Gk4GArSEVrJOCBz8YvaHpzwk9iuVYeka4lOIvudA9drCxY5EUU1I20EJvCSycNffgsg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-FiXMi1dtVF47L4ITblPzzCbgLY9noHwV0ZvEL30bgm4hQPSSNdELFbDAgNuAktieV3/XV7KSOQPPxlc6KEZi2w==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "9.0.0-rc.2.24474.3";
        hash = "sha512-8FXl5YY++/bGTAOoAS7lK53CXyc7vzLAzfmXQ3q2s4vLvrKI3720ECDnDQS9Of9P8ZLDdMwX6SeHd4RbsLMaBg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-P4A/HDIrDVLJBtBD9Eoy2DxofmLXji5zzOBA9ZEWioXurCU5ujFw2VhUiKY6qDedFsq6/1IyVGDNcesd42jgmQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-lCAvZbxLspyp1LgfAE8uCvd9muUNGK1XRAo62v7cxhMDrCopNPF4F36nRQq+LBbyijlCbXzHmB7FJ5SfcQYhfA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-UUoAim2OxX0npr5wF3z9mLunFVVNyfadk5EyE8dkTAhiSULv4mzQhAMRLirPlnOOcvytVgrixBWmE+unUrjJrA==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "9.0.0-rc.2.24474.3";
        hash = "sha512-xuLmBBnsSd915EIhwY4x8UP6LKvVrbTP5Stx6zn12ZE9wf0mzrp92o4zs9xdS+XFjV4sXgPdJ00ayj8vRtqaew==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-e0Rk0Kg5yGi/gv6pBGuGca860xeOTOMjx+A+5xvB6NLaPS7bdAuGgFRhiI0Bs1s8KcuEhnWK4EP8Z9127BR54A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-BU8bppDcPbtBi0WtF8WpGPDf10l+LwB/i/sBYmvmKtGymDkUTZ1Cx535oPA7c0vRfTYFbPZPNEZwlmtQj+gaRQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "9.0.0-rc.2.24473.5";
        hash = "sha512-zIGe6kxRaO8J+OU5LLvxUO1BMu3+GuTcS87aUggVNulwyHFjm60YS69VSpQ0JyWy5/m2cNTcTgcwRNAmU6He/g==";
      })
    ];
  };

in
rec {
  release_9_0 = "9.0.0-rc.2";

  aspnetcore_9_0 = buildAspNetCore {
    version = "9.0.0-rc.2.24474.3";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/bb68e2f8-fc3e-42ae-85f6-ba2bf4bc8ecb/524d5256a3798a7795837d7b104fb927/aspnetcore-runtime-9.0.0-rc.2.24474.3-linux-arm.tar.gz";
        hash = "sha512-1qqmHfZrxCKWNQ9WoT5PWltWdw5izfS7KmR/gNs7ymMuf4tk27LSuEJuhi7fPKdb68/p219qbpTsCFV6T3pGGw==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/687495c2-a3a5-4cf5-98e3-2adfef55a1e4/ef59f43e13c7107ab17e59c276da2485/aspnetcore-runtime-9.0.0-rc.2.24474.3-linux-arm64.tar.gz";
        hash = "sha512-tt5mjOhxRHa+eK4A7WYCfzpbBtlcZ2itaz7KTQ85bJGEMmfA6MAxYLcJp6zcvCsJBH8eyNRjCdQMPTH4ScyYHw==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/f75b68ca-9e93-468c-925d-3ce85f8a4d0f/3a31e60149a0ca0f9e8d7c05666cfcba/aspnetcore-runtime-9.0.0-rc.2.24474.3-linux-x64.tar.gz";
        hash = "sha512-k3DCYXTNfxsv71jgpTBByUt9VBLxXqWGX7xlOmWxSLH5LnmS8UdhCmyi6SAR/yjENICrJqbn+M1W8hia8GEL6A==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/bc4a32ff-51a4-44af-9f7e-fec219ed91b6/4ef16e8019a45a760fc00569cb979ccd/aspnetcore-runtime-9.0.0-rc.2.24474.3-linux-musl-arm.tar.gz";
        hash = "sha512-+mwjYESxZ9+g44mq87jkLRQp8ZOvAUua5oV+LcG2SmWoAoxqwX6D2+Xsh25o7py4U9/gGciLOp+hX8xqoLAX+A==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/8548303d-93c5-4846-87ad-af4c79877a26/6e3dc8573f2cd923959bdc39c8d37eb4/aspnetcore-runtime-9.0.0-rc.2.24474.3-linux-musl-arm64.tar.gz";
        hash = "sha512-YwPe+FCO5N+Xnm7mgBB32n0FF9MgO9/3SjbNuuVwidfHJpHtoApdqnQLKDGQlQtcqO0PoRErfSqxHBRZCd6RmQ==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ee8ef896-6330-4f7f-86ad-172d67793e08/fdbe8aa1eb6fe38e8ad3fe471495d388/aspnetcore-runtime-9.0.0-rc.2.24474.3-linux-musl-x64.tar.gz";
        hash = "sha512-nEGqO/ymPJSP+HPMNBoJEEmEEWfmRMwU8fVD/qO+dbEICMOEgwORb/NHIAOszYAfe8gfzIbZLBpcns0p2b3jug==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/0ffcfb0e-3d17-4b00-8bf2-db75b095252c/5bd0a672caf63b32b39b92c0677a2a4f/aspnetcore-runtime-9.0.0-rc.2.24474.3-osx-arm64.tar.gz";
        hash = "sha512-HdXqCzgA3Ti9piOSgJM2A5ummzrD8agnOmhmTKDCO2MoSKNIuNnp4OdlObbl4VgkMguDBXHC+uPflK0PJiiNMA==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/7a757e46-1c68-449e-8b1c-64293c30242d/aa10955edc95ab4419bbad34f8e4899a/aspnetcore-runtime-9.0.0-rc.2.24474.3-osx-x64.tar.gz";
        hash = "sha512-tirwJSlndP0w9g6+OKgGEviqB4Av/PHJPT2pBStGEQj+XK7DVvlczYdy6nUUhiw3mvuzwZsjyOi1OvmhhAiBPg==";
      };
    };
  };

  runtime_9_0 = buildNetRuntime {
    version = "9.0.0-rc.2.24473.5";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/a0fea09f-b78f-4381-be80-3bb7c363f010/7dbd31bdfde0fd28038f9feb5c24de4e/dotnet-runtime-9.0.0-rc.2.24473.5-linux-arm.tar.gz";
        hash = "sha512-w+oUlK7VbFV0BnhuFtriWi0bCeCG+kcL7nhQID88mV/wh4ujZwehFxnbHlF8b8ulOxA6aYe0/akVjfU2y/0n0A==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/59fcedfa-70be-4166-ad7a-aa724c8d0754/56ab42fd18b3ec36eca8e9a52398032a/dotnet-runtime-9.0.0-rc.2.24473.5-linux-arm64.tar.gz";
        hash = "sha512-NVzbOrCgH74jtwZ5FsdRazFq2jYN6pt3Nf6TXsoXI8obMkB+yjr6fHIrvwYZkAGabVY7w1l/33KUDOs4rirQTg==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/69beb740-ba0e-4a0b-a82a-737c61cb75cb/eff5e94b382efcdcd2a80278e04edb92/dotnet-runtime-9.0.0-rc.2.24473.5-linux-x64.tar.gz";
        hash = "sha512-ugQx57uCrMqxRM8WZsRwVJ2BAqF/JgzX4NmIkjon861cEMrdFgtaGA1bsVlyFD8w/bc7aH0fjMwC6ekzSrjCzQ==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/1ae9bcc8-f0c6-4e58-ae9e-1a97ad4176e7/97a25ba8dd8535ed125d0c3773a8f64b/dotnet-runtime-9.0.0-rc.2.24473.5-linux-musl-arm.tar.gz";
        hash = "sha512-WeLXyzWmOYR1LSlr8CoejCqNsNy7K7zkM3X59+qN7ZOGfOTCCwnAPelOPjNGPxXL+a/wWKkzHa8KxQTEdx25bA==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/f5868a65-9c13-4020-8f22-afbd6ce09d13/7a342e4798cebc6cba90a6569e9dbec0/dotnet-runtime-9.0.0-rc.2.24473.5-linux-musl-arm64.tar.gz";
        hash = "sha512-PekyCYPo4EPrW8MB4yRCVXCyHM8NXrl8Ph/eKrl+mCBtjReE2W1pE74LtLjOUMXP+Vbn+Jge4KHxyd8idnkhKg==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/d9e2009e-5bab-4a62-88e1-ae5e3ed4e0a0/617b2bf0e8292164424e71c342ed8d13/dotnet-runtime-9.0.0-rc.2.24473.5-linux-musl-x64.tar.gz";
        hash = "sha512-1AoYYdTlUKRtTpEEF20QfqoKG+lMxqxYPvMx5q0xzK9NN6QnYgMAo3N2yG8SKpIKK3tAtOSsNHvi1io43IPZZQ==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/cb30091f-cc2e-489f-a8ae-87a08a9d220d/7ce11a740f6d5641c514fe68b2cb2dd2/dotnet-runtime-9.0.0-rc.2.24473.5-osx-arm64.tar.gz";
        hash = "sha512-e1DF3vwyGDOYKU5MuRpZBgYXZ4QIpYbOmB4PR/uDPIUxsw4D/EZXoJFjRgYFcwJB42bJITw4EHfmVHU441bosw==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/b9385375-2ccd-4e9f-9e4a-8d7f6d58c3d3/00e123163e6bfaae9119c5fb355f0d53/dotnet-runtime-9.0.0-rc.2.24473.5-osx-x64.tar.gz";
        hash = "sha512-TSYNygwim2QOkORVS1FhwLnZX4u5gOtT5hlAviLIMoSdMokQfhyBWMgYklh2GidpXppClrkIag1EyMEkQFMfyA==";
      };
    };
  };

  sdk_9_0_1xx = buildNetSdk {
    version = "9.0.100-rc.2.24474.11";
    srcs = {
      linux-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ba992713-4a38-4b45-9c24-8222f2ba01d7/e8746f2e70e0f06e3d9282c6d43bce65/dotnet-sdk-9.0.100-rc.2.24474.11-linux-arm.tar.gz";
        hash = "sha512-c2oOG/d5FSjmyYhIUX9s5x2U+hpacrHl2iybVycJ1Xlkq1OyDx4rn8aOLMc5zbo7kfwI2F6EB/u/zQ1fuxHH2Q==";
      };
      linux-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/817f5589-0347-4254-b19a-67c30d9ce4f8/3dfe6b98927c4003fc004a1a32132a76/dotnet-sdk-9.0.100-rc.2.24474.11-linux-arm64.tar.gz";
        hash = "sha512-tTLcvLR8T9LJBgGNLsZj3hcZF598naj2Kj8hpi40zSYJ+3zuyJ9a7bKjUkf2f1Q6AsaE4WkgU7/y/cQYTfY/Uw==";
      };
      linux-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/202e929a-e985-4eab-a78a-d7159fc204e4/0c85219d441cd3bbffd4fb65b7e36fe5/dotnet-sdk-9.0.100-rc.2.24474.11-linux-x64.tar.gz";
        hash = "sha512-EmqSv6nvTnBgn4snzeD64bFEqRr4pG3pSdgD0qobrQKFsbm4/GDUAgbTRqrEnkhwm+xOds325Un4kFCGAD6AmA==";
      };
      linux-musl-arm = {
        url = "https://download.visualstudio.microsoft.com/download/pr/ce9a6b41-d58d-4def-bf4d-2ff6a022c846/321706c736aaf0391a642d5d1e4d3e1b/dotnet-sdk-9.0.100-rc.2.24474.11-linux-musl-arm.tar.gz";
        hash = "sha512-pzn40pdEFS0zt7O3SThvD1E7ZtHy42PBCCu4dt7TiOHMbdJrD5ArO835V07dOGn4ALkjZIw92pDckbdsStXNlw==";
      };
      linux-musl-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/add40efa-8de0-4fb8-9ac1-bed94c85caae/30527cbdf0f429eb778ab03f2fadf896/dotnet-sdk-9.0.100-rc.2.24474.11-linux-musl-arm64.tar.gz";
        hash = "sha512-KlWo4OMbUg3ZzfPvqA9Seuh77DuA26RLxhPKq0dWtz0fFFCGSJ+rD1WpZogCmsoUBhriWNHc/Dbt6O4LKo9Htw==";
      };
      linux-musl-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/5e1ed970-6da9-42aa-840c-784c63c3a1af/4bb5d67f6983d22667d4d198d6e72ffd/dotnet-sdk-9.0.100-rc.2.24474.11-linux-musl-x64.tar.gz";
        hash = "sha512-JCyCo2HXOcuZdhnJggR7BfpGyNclZOq4TaSdK4Mb6xxcvyveWA3wtoVYdL8aQ2CiYxkSd9VgLc3GoBlDWgDO2A==";
      };
      osx-arm64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/90c92374-0f9d-457b-a612-13cef4db7507/fc5ff8876123abfcde954906215ed1d0/dotnet-sdk-9.0.100-rc.2.24474.11-osx-arm64.tar.gz";
        hash = "sha512-wkVoXBJXKVaXrqxs8WnNY3XX5yXruHYO/OvsOfpuv2/jrVtgmUJviZ+KCgMywEeXfef4QypObyijSEiRSpJboQ==";
      };
      osx-x64 = {
        url = "https://download.visualstudio.microsoft.com/download/pr/33f4f5cb-7423-4930-8e4b-d96f1fd088a9/87d414df2c160713cdaeec06c62cf6a9/dotnet-sdk-9.0.100-rc.2.24474.11-osx-x64.tar.gz";
        hash = "sha512-EY+pVt0zDQ30SeFGhbNi4ut7RPvpVBuXwSXZOnjcLlMCiKO6Hro5KNMF9KC5JUyEgMC4kwQYciZnn5W9bxvHWg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_9_0;
    aspnetcore = aspnetcore_9_0;
  };

  sdk = sdk_9_0;

  sdk_9_0 = sdk_9_0_1xx;
}
