{
  buildAspNetCore,
  buildNetRuntime,
  buildNetSdk,
  fetchNupkg,
}:

# v8.0 (active)

let
  commonPackages = [
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "8.0.15";
      hash = "sha512-FhQhAwAbCo0xUMBy6LpB+tMgcY04sjOgqt4O5wupIi0R7usPz4ZNa2zRqUHpZM7TjHl4rObxd+l2sTe4uru5Ew==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "8.0.15";
      hash = "sha512-A4ztAaWB1jk37IwRVblTvhBbx34dMGVZoI69dVVD6+lPBY4s50kZleRt47oaLs6/j8FyCsJP388hOW+jMKphWw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "8.0.15";
      hash = "sha512-wwHBromlatQTFCY5gKFiusdDH4FcNGjWQ+TdezM2yESbNHueDQgtkQkBsLVf3tmS3EVrgWnZ2QKQqiJguvR+mA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHost";
      version = "8.0.15";
      hash = "sha512-gu8T4Wv+pAvYQsqsqjiiff/7LfIWDVadnWwGra3zf0NGIe98LIzAogx3xkzJbG/GPinPpXr1RCF0jgRkDH1qxw==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostPolicy";
      version = "8.0.15";
      hash = "sha512-P4dIx6GcUGS3NKGpvIncjVehOqtZBj5dxOEaU4kdGfpXsK13AaBQAha4oiEwkFIlb6kt0At1RPpT3RnSouNeiA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetHostResolver";
      version = "8.0.15";
      hash = "sha512-ghZ3yQjf58OigMMtuqUSnUeOpHWUhszUc/Bv1O7jcGMy152wU6eRWsa0kNVC9l3Y9lBa0T9V3y89Us+PM0P+eQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "8.0.15";
      hash = "sha512-4H4DmF3CNXSOIpEUo1eVxA0Lt0YT67sixjDdRCjuw6OfDHTDAoxo3OtRYirzzpetFYRhSICOJ/zIjECtqJYZqQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "8.0.15";
      hash = "sha512-MnMlsnCehIX46CH6RCnbPsX06DV3oXtNUz2hDmIYzz2Oca7gf9TtYQ5t1/afObfSy7sutqgmaOmRng0R75kRBQ==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "8.0.15";
        hash = "sha512-XoTtttWBuYlqcXPK166EvPC1x60ypjLXtSQzhUopHg5+lxztgg/aTDsxH+TxA8UH/EXaR31Tata/UIgW0zKXbg==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "8.0.15";
        hash = "sha512-EJx2Jr49xV6NJZK2AxThscHWiVcinvXd3LTzI6MjVB2OySn0qNfqoUSpUHhNz1ADJRJXB2jO+LZxM4YuerQSKw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.15";
        hash = "sha512-Syg70nYx7oyxDPWJfQFVnuiR6Xnc/gl1e7o7t68ZcfcHqoLBl6wgnxw/ePtmyqi7AgO+5iBs/JLadl97d+bSeQ==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "8.0.15";
        hash = "sha512-+eissRQ4qa1RwEWiR7WD2Wp+sC9bPe4+eVhiGODUQH6d7yRPXze9IyQJdQtGdqVCV0++p2bE3/SQ73cNcNgGkw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.15";
        hash = "sha512-b/u/co1T0RcPgCvTIxH7Hv4Ijag329sDo/b3W1mzJvdUDbeiAZiEoGbX7TPQsLmaf+YD4FreudmqFXhLBuLEJQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "8.0.15";
        hash = "sha512-jXJ9RVLTnG9F9AHefJjg0g0WPpGzWFoX+oYQhVBMUwYfferGDo3wprAXOyzbekNOkJwVJWWIOH3NkNqk8QkpUA==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "8.0.15";
        hash = "sha512-xJd5QkN2rwAtDqowBb0MeEAhDZQ4gCK6PobtqNF+mbVxCtt1iylUvmUdBkejyzO1DPyJ9cnmt9g0W2XD9/IpeA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.15";
        hash = "sha512-7GfP1rYa4sR42nomqWsm8nsahpntMacfzDO51qONxwfNqzFSYUNjvMww+dUGGbXGfbAbOtMjvBqYcJWAiq3eKQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "8.0.15";
        hash = "sha512-CzIusWJPdzqTk8jRsd86fsVn7Di/mZG3EJzrAe1c4weii1mV/ry9yCXhvA6zUEjVvzO9TA1jMye7eUaBAnBB5g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.15";
        hash = "sha512-DmcMpU+1GPbbnqluQlKX17smSAWqYlZWaUIjciSIPxfYciw2x4JWyP1Hejm+u9V1AvNM1u8oelB2RowPhtSgiQ==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "8.0.15";
        hash = "sha512-NtGjeAYFTpWZYdaWcEa9ioQmavVrHswUp63hUM5kwnRma/lEbL9e6XP+1N20/YAvc3gOgO7WwU7qhPs/EKoUaw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.15";
        hash = "sha512-gsm6tMz6QgLt9SRd6K8nyYYc2aJO2zphmM/RVwjJsm1HEUoERugA+CSBjkma2bChFU24oOS54Np56l5eU6kH4g==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "8.0.15";
        hash = "sha512-kEJ4uTHbNdiJgjBKWL/EfBFmT9wvqgFs4L4Mmzj58YBWDu4daR4ojE1Nq7nPigCehtFFkbvsWtu9NK9Xo/dOVw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.15";
        hash = "sha512-8eM/FH81oZ9e5DErjnMfEBbncqelSlw1wctoZOqKYM8vGPUev29q+MrmsENdBILQh6Wywoyz57yL9WoVSrig0w==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "8.0.15";
        hash = "sha512-axGBDt1oCr+72qNTd3+hWBZIZU0IlC6uKX3wW47iBqoNkDIzWwVnapw0AmcS90T+GW7R5yZhaNInb3SvsefaXg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "8.0.15";
        hash = "sha512-jivoMimThgj3Vv+24T6qzLKfEvDIandHqhEGJ4B09VRF4W2cu15cqItf7TsqFmgyFAQOHB+uuOZERAWKucJQ6A==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "8.0.15";
        hash = "sha512-OLO6SHlfiRiD815e+DP5pOWoXfiYzz5tk9KeZmS9ZtaLWWbIXEbeVyb9r150s0tFSBU4WIXBkWs2KI6+/VHxIQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "8.0.15";
        hash = "sha512-3XwkREPGrtUsbV1pBsb7YoIbqHHV0w0E2l+K7CM3d/cBoW4xOFKtECsBxFJ1eMcqRASzRRNJyyfdoq8799MVYw==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "8.0.15";
        hash = "sha512-/wZ+EmaaWLURlU1Sz0nUbHuIv04lyorcyM8icLexsxSm79NYTyCg8oJ+tczE8kpkNMwuvDz8A3jZqI2ICA5/Lg==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "8.0.15";
        hash = "sha512-FB5+CWVSZymzAiTNwehM05R2J6GEpGccsMNKWZR9xGto8MNIf25HhsjCsH5hojJrwdbRbxXHQLNSidE7MsR0UQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "8.0.15";
        hash = "sha512-i92NoNoaMMUd8dIOhKaKmwU3aLOEh3u6d3VOpnFI9m9crFDRVe0FTKPtCXwPOGMvDMmwOoJQUV50beKY91nVHg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "8.0.15";
        hash = "sha512-lrIPRRX4gCaOAnRA7c+NxpsOIemZNkWHUtyHIruXVcRkLIJLl+QNKAdgsLjqEJRrt087S2nPj3AUz6TJixS36A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.15";
        hash = "sha512-jkJtd9m7HKpjO7oyB2JtTGCERzrfjVwZ2T9m5KSMX221aGvWe0TvPXx2i1orBi7lWMqQ9pR/uQ+5Lsowf/6S5Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.15";
        hash = "sha512-4Lc75UYVKJDoRl20jkmL4SMTzUj048P2MbrGABTlp1KTZK2adw5RzD7cHU7pxKjuKpht408Gf/tb/1Sj9faCiw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.15";
        hash = "sha512-GvKKkPcXkmwFEFEYDDEl6T+HU2En4HDz4cEysMDiwu6Q9cSuTa1rwm5XDqUzK89J1YrTeoHiyTJIaOJZ22KQ7A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.15";
        hash = "sha512-g5RqYI7EBF7blaaqPfG+PAZwSQnPwWy/7/ogKy7i9Dy33G0yZ+/mTN4iMFxyCY5pptU94M5mFsU3OySvD48tHg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm";
        version = "8.0.15";
        hash = "sha512-gQNtJhLIhrS4lStAIQ5LnRhlo0fA2yGzl4t3qN2DlI/mmVcVAevQxRlC1jAKkpsHzM4XDVHBpJl3l6eXQdVNSA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "8.0.15";
        hash = "sha512-Nwa5IVNw59QmwYgLd0QgRS7HPcujRH70EVCPY1uADEaXcHw5X8uXF/6eyS7i+Idd3+2T9IjU3RL823ULKsm+Uw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "8.0.15";
        hash = "sha512-ABmyvhWR04RmwVHY+b69QvUEJbsYB0jHrHVmJHhHYL8iSJ1LTv3Q43nKU6t1R+cemOVfy17CRHvVpBVrqe4/Ug==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "8.0.15";
        hash = "sha512-8qZa3YuY5Uu4D9cgEzMezCewK0cQk2+3/jzRo+H7GdWn03724iKRDcBvVrf0M8tslu40FdmFPZp3yOWx3wRAsg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.15";
        hash = "sha512-2Q62qV43seDzLhNsNO7UT81zn/NdXHNiBpSkyaw+XISuKyRSz6foV0OZKaVc3NlJm5dEE/hX2Nwhyh6tq3G/og==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.15";
        hash = "sha512-HIHvG0D+9sZPH7yeP+7wSC09EgdedBr/SblSV0LkIg2GkAPUsmC8JcwcX9H+oLdksYHAsJCYwFMxxMt92rIQyg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.15";
        hash = "sha512-VmJGFUr1sV3G+dpiXV6uEoy3pjN6Xaxnfj2WdOlbQb9syABFvt8W1C4+hZr+TZAO46lx2QY9lQkMfDOKkI0+ew==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.15";
        hash = "sha512-VDUJWB0ML11vjXbhVnMwoc+gv1opjT14V/+O7Bu9O4VhglOf16X9OEen8OEChWCyAiHH2bL6Fij1lkpYArocXA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-arm64";
        version = "8.0.15";
        hash = "sha512-y/wcDYSv7P2Gd/FDLudGCmp+7UAlEXF64BS391Zzf5q6Cf6pSzw3SW9hmPkEswseJEtb2E9JHXz37dFY37vU7g==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "8.0.15";
        hash = "sha512-74QA0OO8eW/Ux+aqMuna/pW24IdQ0+I1aYHuFiuG/hbuJTzV3bzZCgj1Xy/RJfWeWzMyOZE9RuDdIOalkO0h1g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "8.0.15";
        hash = "sha512-20mA8ab/UMznw4dR8fm+/eTAUL9s68jSmo1KLyVhej5adk8WcciIgd5zokrpJUD9iE0+2vufILw6PXwRfLcLgQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "8.0.15";
        hash = "sha512-QB1S5s7DqaAlekzYmSDx3xs13jFr3878W+PQW0n/gdvUeqvjNCGiAChhqQnF64DTvaJ0xkFOIr7f2AbleDVaAg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.15";
        hash = "sha512-ADWyGJHkZ7eY3RMMvXSk+/86JDylPg1GmW07rhkgtHAvnmMZPnKBYDTYZF5xFYJJ0w4xLJmeCVINFxPHOJyQCw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.15";
        hash = "sha512-0RlBxvSBjYfadU25bcCdkxyKLJfDgJycO5gxC4/cJyFPCoC8adryo90jheVj4Amb5yrGg1uo1CnTBsWhM0J23A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.15";
        hash = "sha512-hdPRpcAoUmQU88Ycocy55AgdKMAd0nkJEE8Dz+Tq8irmGK+D/lFpPk//QEARtidhh92mejmmIeSF4Eh+qIb/uw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.15";
        hash = "sha512-he+B6x62ju23jEcUdU7ii0bIyqFrhfvQliJc+wJ2eGR5bKLlEIcy7CpqeGIi6qcpa2FVdwsiW1ISk0Wwb/IKEg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-x64";
        version = "8.0.15";
        hash = "sha512-7Hwcas9/rRIcxe4SbAMMFHCxxNS2soGszRv61I6ZgNejn7IIV/Npgt/t9LaZWMMHwMG6kTCxBUsJbWToqDydWQ==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "8.0.15";
        hash = "sha512-ENa8FL1tEoGdsmpDkwrOJNmmOkDz9nJ8mxTnCHxB41WFkfr+0wo7WaZsTlEDQPQ86lKk75aiT5fqfSQTVeXl4A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "8.0.15";
        hash = "sha512-56i9Jhoj1hBALQgaD9X4Z0XWXdLH9Lw7yrMFlybjERUa7h12cWlLrEhPNOvMluzfEPruxTHzdmXKgKTb0BIt2Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "8.0.15";
        hash = "sha512-GHPoVbx0cOQEpVBHH0Ih5lJPyAPtYHsmqiNdz/eR/FJw6gc+ZKMn0vvSeIF0iaBcMX/X6x9PcVqlrbGD+BlLRQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.15";
        hash = "sha512-suxTQJtqUAgugQVsK+79qvedbqC6yT4URkyK6k3HVeazpspk1cqn+A3r58e4zjy27rjGAQ78oMZ/nb+hiiN79A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost";
        version = "8.0.15";
        hash = "sha512-0v+GoHGdEmMqZg147sUsm42E30iigJUFG1h0GZICou6IRb3d9WTFK6eLnn/ErN7FAfPmcyFyK+8TADM8LZnrlA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.15";
        hash = "sha512-JDCLE+YJI0iuToNrf9V1978XWsNjx7r5jUKVIHIn8gSe+kMjZDM3IszMpMq0V1Kj9h4ko/Dp8C6oiClUjEkAGw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.15";
        hash = "sha512-gcIU1EBdA7ReuPEZ0rxVJkt6/fZ55nQA+jdIRy04xPNVrEYdDWJ27bfINKnvxKj7aN/cRVM2xHagbiYIxgyqbw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "8.0.15";
        hash = "sha512-/gcOujy+jgXgaY2aZEWhejc2u9waMjVH1aHBn/YO1ZD5GsetynhdCvSSY2D/7vb+F0l0K0lJySUGQPqNsGLRng==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "8.0.15";
        hash = "sha512-8wfjhoiE+SUzzUQ0yr+kxSDIY6lEh7REw4bmEiTKemP7vtmcQT2Y/xLeu0ND+VHfRM8tRXHy4HHhaoWvXvFKkg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "8.0.15";
        hash = "sha512-yZLsIeuoD73jdIEWrOErfU2rb0l7HNfHGUHX40SmjdPMFMrrp8K6oN2CnebupyVF/0N8CrOGyIO3VTzbfrrgfA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.15";
        hash = "sha512-JjedHSklPNkXZyMBKvrJTsbCqJ8SQ/leHA1S8niVk8g4UIVzaywZByjvDRhJ8Bu2IZEvQM42C58Ufy/0EVW4Ng==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.15";
        hash = "sha512-0Ea1c8JZ80/wG+3ea0VYGc1lSC43PT8kffVYXHVAat9sHyttty4nECDs16UHq5huSldwfqD0PTa91mwaIeMQqQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.15";
        hash = "sha512-+ncaL8reGvMfULx5KAkwEuViNhBH/B0b/SFJTWoZ4hNjv8mQJP87hZL1i/dm3V+Mdx15lwKacTRMoc9kq749Tg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.15";
        hash = "sha512-nPRpOYzddjtC9lCM+8VUAIXDsmFQ2mJUC6d1BnjK6J2hWmKS4rjbteZM4mL3xEyrv3LpdxTO9e4eus0wd61Ypg==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "8.0.15";
        hash = "sha512-uE8GWC6smO3Cd4iU90rCnaUTWVjowariZOISXC7hWfWnoF//XpzD0l0/MO9aStbejKFXkQXXPOWkU6GorM8QgQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "8.0.15";
        hash = "sha512-MorTXQChHzd1I+r+SgRWLTeiFAY21bqkDhSmQLbXIp4kv+izmjRoE5/f+eMPygRQwUzKgUCAl2ZkguXVbsOTLQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "8.0.15";
        hash = "sha512-EA4xzB/r4u3+ka+UYIiRXqnQ4KeCQ/hjXP+YJGsSPF/VALDUQ/P45FhwMI+uexotG9bJDJVnjoHMSZ5ncgeLzA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.15";
        hash = "sha512-0Sqevxt/3D2ghpF55fllpATYf8OHXM3CSB4o6Tk4rUbcqeyZuSLSxNnBeatzwlquPEPmwr/F29pxH7eJdENalA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.15";
        hash = "sha512-q7DcrpWV6zlRwvvwt39qnjXnZx3lkBrLku/1G71NGrgeeixXHddr8lc+l1IfH1DeqSKFGifaeq+KnYzv2HOlQQ==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.15";
        hash = "sha512-zelqI0qGvpAK4Mn8JacG0FWVyHMVyj0OQzLKgkT+krrUofVf+0EsmoeTrl6fkIXrzpuRC0VY5bEAtrAi8Lu/AA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.15";
        hash = "sha512-WqBHZ8Z+AK+3LnZNeDVX/FfDK3RcC2QnV84+fz/MD4LQ95MSPVAou5ugr3dIzJYMSc/O+/jp4rokLcBdUreN8g==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64";
        version = "8.0.15";
        hash = "sha512-47IH966HOA78LRadNZArpUzHiPDbiUSlnJyyp/c6EbR04mcptIoS9qCl9b7nbY+sOXGgu+J4KCFHhWeoQzF2ug==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "8.0.15";
        hash = "sha512-y108Qx0KKsBg9X7YnL4RS6KPFJkpYUGvENR4Imf5lZZshscH62P+sttC6BJfvyt9PAKM/M7zFuLIyXxUcBCWRQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "8.0.15";
        hash = "sha512-Y4yq7znZh9+COYXY5LUGoZeZNtStPgcvtf+4t0iR6KC4FRMdvI7CLyZeqKyxysubn28mtvWnj3+qvV3SviIo+Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "8.0.15";
        hash = "sha512-DoJ7Dlmk9gt5FkMiZkYUmUcCTJYI7PHKlMQr+m5Of0xInoZxIJ+lQuNHt+8PxuM1TmzAfHsM8Oq5pgYYpN11dw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.15";
        hash = "sha512-GHmaiZ8rqNhz6EUdc5EXaHhdhkwh8xNN7UGcAgxvxrDPaiFp3EPdQ7yPou1itg1/13qi7O0k8NOBYQEmwlioqQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.15";
        hash = "sha512-HAp4Oo1174MGoANdEeR3/cdLjVdtsSfaI9muDUN6SAW0nBQ60o69om7rXtt/QQ6k6OjYZyOfpxMAs5itQKuCAA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.15";
        hash = "sha512-0qwtIdsKLSR9m4D4gJkaV39xWD6yCdnx+9FS+ZXMMmTP3rBIwKnvnmjK509nE2jdEkAYgkhtrZI8UGLtHBD9Ew==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.15";
        hash = "sha512-Tkt2TWYyrVXrU0UnKJHCfyy41G9wo5A2+2gzDProYAqucUzDALyY73zkPK64t+3s5nXoK+f0T0AybYH6vo1ohA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-arm64";
        version = "8.0.15";
        hash = "sha512-Ob4GB13NtMHGve50UGyw9v/x7fBLOvYLh3mGbd33wtqk3eP9fx0GY0vcmdcDZC8DASHNr0IwYaDLkimqmGA33g==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "8.0.15";
        hash = "sha512-2dWFNk333EB5KH/Bp7VS2zuwvjXNlmXNMt2d4fflMw152cASkUDQWFnA6l4xR+80J+U6sDOfepyvoyhUnl+bHw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "8.0.15";
        hash = "sha512-O3Hl7PiW+9nGahbjJr9DNrbhoZW+shP4ksEiElJsYAiHHmFyfBGzNXaoLZwZE++SYPyimY2FbXf0K4o0SKPQcQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "8.0.15";
        hash = "sha512-3KTK+NArVuiILnBaqSPmRS+NhNyw9qIWIxS0C75a9GEyZdzM+zP4qzXFVYe1hTnGSSLU8AVb/CXFRyntvsdWAQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.15";
        hash = "sha512-zJ6yS3kOC9HBTSRhIO1BnVSdJgWb6Lq7RAbU8kjAtkT2rAoO/ZH2PNZ+HX2yVlJHY11G9f7tSFAoA4/UVBG6Dg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.15";
        hash = "sha512-KEaoTOQpBHA9so7SknNBU6CfRAa5eiqy5Es05Iie9vOuDY9Dc+Gt0gPPXWj2iXKBpsbqYSX6C9fPdlY/5r2IsA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.15";
        hash = "sha512-ydluJPlRlEq/RIkwNSw14C0bDfQTMDWYbGcifpjoVYdHdA25mztlSXEpoVc58M0kw+ObPkxUD5IQdirIuum0qw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.15";
        hash = "sha512-1wo7VKiBoLQDaPOzV2AGefGWHWFyIyxgBIbupzDEBEE/EFzLfQIb0MM+lCyCB3e07O4zLud/mNoT5DO4LC/+mA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.osx-x64";
        version = "8.0.15";
        hash = "sha512-N+al40/C0rFzjoKpnYX1py3Dy+jC98inbYHRJUxzaKbcYGzhUo4H2FVl84D3AcmFSzNfOwV7hoeUbeGXElsixA==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "8.0.15";
        hash = "sha512-4RiClomUAm7QT+MZtsDCqIEmcXw7VYczlORZHFtpfPLtvTUt4oKoUovBzPrjdWjoa+f1kBxY3s281R4DNi3BsA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "8.0.15";
        hash = "sha512-TpoDIcRv1mTWnmeLSO/WIiYLdM9HD38NqvCyPJv4AtTQJNwZmMBEPFg95Lpm5NVBuUiLDVMrwXNbi5q3a/oopQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "8.0.15";
        hash = "sha512-YbNUZ0vgknKFe/ZZ8AC9Uri6mucffE1tRPbGKRdBWklAPzwwsHtWFerNdDpkqNfdRuhZK/AypY5gXUQRxDghEA==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.15";
        hash = "sha512-tAjRGdHqt+nONHe2kXOujrv8QKD7nmtZ03xkJ2JFYcxPgn5bPsXSQim688xMPScj30cONhmpaDxQrKR5GQNp8A==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHost";
        version = "8.0.15";
        hash = "sha512-wVuU3yDLqdBH4qy7FjeHgaRQ9ROISVv5n8VgElc8j92tt+xKMeMMcOCCE/KcxFcAGNJeOPr47HHDG7H12xILog==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.15";
        hash = "sha512-nXf24GvKYZVNdsYKTNwu4Q5f6hTtrI/SXgxR2oUVJBIp+jJLFq57gLUyi5HybEZ46Gv5E1cy5O8bGzCy2UA30A==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.15";
        hash = "sha512-Fv8t9sTyuIiQvJcl2achPXXDosNBNMuVWPEG56HGLOApAdBHqz0nsnvq3MafYxoKuWErF0Q0MtjgRBzmzCdmHw==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "8.0.15";
        hash = "sha512-BB783haPymdzS2yTLkZ44iCAxzvjmYwenMP7PFqefbOX5elxs0m+naum1zV0uFkDc+jdCZqjrb0PwT8epC/mKg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "8.0.15";
        hash = "sha512-mNH9ZI9MRHcMvlQOHtvtYHrGU9UvRhGb0DhfdKGHXWekRANnAyxXebcKtPPjM/ZhcPJ+5bUdS+ovPc6Sj6SzVw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "8.0.15";
        hash = "sha512-JJFZocAXIGPYfQjXB3SNZ/FI3uTzJBDewLFczUyRr/0clvf2VY673mO6EMZtHKpA2J8K6j2ZMqMTPjRy4G0xIQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.15";
        hash = "sha512-vH73AiC/pHTkHnBW2YMP9UQp9oOcZ8WP0Q74oe00QkS/p2cK5y0Ocozgn+2uQVBlAzOgnBtAHGu7jolI8K6Txw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHost";
        version = "8.0.15";
        hash = "sha512-d8uEdeqmFW5ryRLOSRdgx0icO2b8IVHuUC6euC160n0EfA00NE1gD/ZZvU8qzKgHkhf5X4eFpTurEN4yY2LBUw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.15";
        hash = "sha512-++7ZVCmb6wEGaqMDTZyvymMH0Hp2LeTMprM0jqXiiYKl2asMHQVnvdI9X1dmDG9Rjv4hrxWNsY6mNtZY8n7f2Q==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.15";
        hash = "sha512-5xufQ8e+XKkYK1ZF1nE4XXnIaNyiWu9j39GGgOVU6qPmpkHtQaLnuSfkIHhMyD300B5ni5fsm1o0l7YOSTUZpQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x64";
        version = "8.0.15";
        hash = "sha512-RIcuCNTOqHE+WYMg4OGL32K9U/MqhsBjxgbOlkBbK2cQoO/EdRlYTQrYy+gpMx0CtmXXWZmjyYYt2LR/Zkg05g==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "8.0.15";
        hash = "sha512-ofw9x4trDTeDQrVnA+vk7Mf8Zz3oP9ZiJMQPZr+o4gobg5+YfxoQ6UH8v69LL0Nt24zvCp/9ynnSyjt3PGN4tA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "8.0.15";
        hash = "sha512-1xWsFkYggCgoh5qW6jM8LwzkKrv3g6GJeDkxlACP3aXPr7eOYfzAXIzFxnmHl1k/Le3e4F5DFU/UWqQTKMDTXA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "8.0.15";
        hash = "sha512-Th0qQHTOw3ypNlOf25r76C9WXF1FnNbK8dWlpvPJcQDR5OjanOhGPjm/oswZo1Av/e214CxuvJ4xMEGTv8Mlbg==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "8.0.15";
        hash = "sha512-Et/th7G3XQuX6+RyX0+UgT3PkI5hBc5g9n/rsC/JolJEZmgE2CdtdPTrHZD6p9QRT0pa92mGY2kX8eWTMWYiyQ==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHost";
        version = "8.0.15";
        hash = "sha512-pSst0VqWEsUMqA9A+jZ5rDTpXsiYWebChRWpdkPe0MsxFILWLCErKphT1bXWCxlsmH/TqUX/SctiqTHI9CS92A==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy";
        version = "8.0.15";
        hash = "sha512-pwoYsF3WEMRxLmM/TqwwPGClFY6Qn6RvlbB1oCIQ7t4FxyspMu7gUiSH4HNumifdbjoVYuPNt/M36KotMbdErw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver";
        version = "8.0.15";
        hash = "sha512-5U6JMrO+Y2/CNCCG+SVR8+8VC7dkIrOgGcrEZFKStegeKtEk2sbt8cMccNKGXqKWbJSpaA8F5Q21gU127Uzs0A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.Mono.win-x86";
        version = "8.0.15";
        hash = "sha512-KnQvNLSklPqPyVubpJ31SoNYr0WDo5fNbQlO8brTDJSqI3gyTZQ5QOjBmTYAAcwi+jLjl7mrJMuME3W3ZFx4zA==";
      })
    ];
  };

in
rec {
  release_8_0 = "8.0.15";

  aspnetcore_8_0 = buildAspNetCore {
    version = "8.0.15";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.15/aspnetcore-runtime-8.0.15-linux-arm.tar.gz";
        hash = "sha512-CZXllsH9AvXomn9pW5OXavJThB7zD+g6BTEKP89OBpaSxWIOgDVdzT/mrjLnta264Ls/D/NeM0wvKPFMRNym7w==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.15/aspnetcore-runtime-8.0.15-linux-arm64.tar.gz";
        hash = "sha512-ln1DqTh9Im7YBM/uNRRKafJJ9iBrc+0NiRXa01j+3jxd3D7JY6XDVAC2LcVyZdodvAfXk89eOUDOlOVHgzEvDg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.15/aspnetcore-runtime-8.0.15-linux-x64.tar.gz";
        hash = "sha512-PKVmnUr/YPG/jOy5neBda0idsVDKp8GE0ai83whcYRUz4FrXvQxQkccmhQYRz/awR375sduxkuvpBVwD3hz22A==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.15/aspnetcore-runtime-8.0.15-linux-musl-arm.tar.gz";
        hash = "sha512-/WiQiQ3Q/M0T2BcBHlNiFN3tGw0Y6s00aVR1GkZC4NblvNz6pIWWQIX1cA9BygCb2U+Uj/znBaIf+8xBnKLaow==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.15/aspnetcore-runtime-8.0.15-linux-musl-arm64.tar.gz";
        hash = "sha512-AlsswjWRoUdXVfw7Mh59BarNo0xWFhcOtH5IQr2XikY21H2HwGZtrfdZL/2C21lCe875U6Cl0YQtjDIdAcAebg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.15/aspnetcore-runtime-8.0.15-linux-musl-x64.tar.gz";
        hash = "sha512-r29tf4S0BPRPLzMiQHto85Yt2wag6lfbdxPO8hmArTeZGaIDXGCqewKNByA4H1llR0tkRGybJanlgoljHgTBWg==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.15/aspnetcore-runtime-8.0.15-osx-arm64.tar.gz";
        hash = "sha512-KNzFUD5ut2emVeZ/ad3SgA0Zzuv1lcxTiu9KVnv8trKxBY2aPeK99/E5Xq4rjEhQKNXGfunHC5qwFYqw4I/oXA==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/8.0.15/aspnetcore-runtime-8.0.15-osx-x64.tar.gz";
        hash = "sha512-VKz3i0IUW0aGq1XBrkf/sTZezcvncYVXLvKCX96crdERtSYEbVrEAsuwRre8CYgNh7VvIEYfxHUYmsg451OlWg==";
      };
    };
  };

  runtime_8_0 = buildNetRuntime {
    version = "8.0.15";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.15/dotnet-runtime-8.0.15-linux-arm.tar.gz";
        hash = "sha512-K29PcoX5zcOe9IRkCB6ZYqHwq81GjIToik0Qp+F10w/x87WMSKSDlY+X4aM6XIoiNRAxMGa1puWzXQ3q2G3e+g==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.15/dotnet-runtime-8.0.15-linux-arm64.tar.gz";
        hash = "sha512-9jNZpdpHmPj9+/C+79CqnNadWVOyYpvBxo7MZwg1cvqTcKicGOO0vcI2cd9lfadW7GMGlR9crfIAYqi9d+pADA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.15/dotnet-runtime-8.0.15-linux-x64.tar.gz";
        hash = "sha512-gzqEhUG6b3HIeSFokUhW4W3m9xzwpIHFmQ82IrDj+DEj5gJLyr9rlVp8kujpBBgdQNO9YSWVoNjEekISZ6kcpg==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.15/dotnet-runtime-8.0.15-linux-musl-arm.tar.gz";
        hash = "sha512-SnLLPgo5lKya2MGL5kphidViISdM/zHadL8LiroC1oJg8Falc0dz5MSjSFH+QuYU53IOtRlzKPXnYHb4UMV28w==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.15/dotnet-runtime-8.0.15-linux-musl-arm64.tar.gz";
        hash = "sha512-pSo9JRgwH9ZXGhZiC4gCAi2ndazXDXgZW9de1HKcDSH6TxtbhoacEfufO96oeN6rw8nQnqMdjSsuQ7wi47dvPQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.15/dotnet-runtime-8.0.15-linux-musl-x64.tar.gz";
        hash = "sha512-Qk+z+AfICScXUveRiavuHmz58jJuHLtYZsvAMNa23q6Yo5E/tey1+UT4wThp+kxTuqGd3rocKwf5rnJznwYadA==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.15/dotnet-runtime-8.0.15-osx-arm64.tar.gz";
        hash = "sha512-fnDNeP68+VjCCU3gxyL4M4pjNGNoWqI7WUnQGt20iCLfrMU+2cTV9fzihsrzZYfBGMJLc6kB3s6nacpsrQQN9A==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/8.0.15/dotnet-runtime-8.0.15-osx-x64.tar.gz";
        hash = "sha512-5Ii03KPLCKFEtQ1EKOQYW3qM90hohqz+6PwAwRRb2C17x+ZqzqdqV1hp8WV4urxnCP4QRYOd7KbKhIGIylmlHA==";
      };
    };
  };

  sdk_8_0_1xx = buildNetSdk {
    version = "8.0.115";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.115/dotnet-sdk-8.0.115-linux-arm.tar.gz";
        hash = "sha512-dVwMydPc2mnIBI6BoKrZKyPcIvgyHQRyHVSQ1mggRzYik3siCfRFeSZBtcQjiiT8wG4x+eKQEGri84g78y4/yA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.115/dotnet-sdk-8.0.115-linux-arm64.tar.gz";
        hash = "sha512-2HdN541WcVexgI/vrMkZUpxBF1/6RohtJeFHNonCIWQ8D4k+3zeEbG1v5rfPQIZ2dpFw6MYTyA6v22eJLvbFcA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.115/dotnet-sdk-8.0.115-linux-x64.tar.gz";
        hash = "sha512-86+gw3/QSB946svY8yavZlxOZZQGftrBMJlvUMUnNwzCQ50alIQ9zMLj79s8RG5hg0loIt37aDJld/JqgE6sUw==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.115/dotnet-sdk-8.0.115-linux-musl-arm.tar.gz";
        hash = "sha512-ezvMoXqhMj+qsQs5ooGhgg0gnVv0el+tiCLRN/ICze1OPHcvZ+Pls3V4kVVurA1dlK2hgEwqutexHl7wO9T+aw==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.115/dotnet-sdk-8.0.115-linux-musl-arm64.tar.gz";
        hash = "sha512-1IoK973l7ux8WiT2KXOkDU0Q5p7BveHpIsvIDdjJulpYnnrgjEg4t/w/fi+ouS9b2TMOscWnrC5TRPbpFbu34g==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.115/dotnet-sdk-8.0.115-linux-musl-x64.tar.gz";
        hash = "sha512-85gRr5Tl0u4nh8B72jYkpxPJjRXyE06pdl+M+eZUJ9jzj9muuhfr2TbjVmwmoBHpxLWAbOe6Pf3AzGp86W0wfw==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.115/dotnet-sdk-8.0.115-osx-arm64.tar.gz";
        hash = "sha512-KhL1EKdxZ2hjtCPanSg9YZ/hA+K0w3K3WNlWMgvmztuKQCm7WkbIzNpK0KHsJL4iQo6S3kpTcgnyssNU3UiyTg==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/8.0.115/dotnet-sdk-8.0.115-osx-x64.tar.gz";
        hash = "sha512-10jae5HVdBEd20h4ZaLPNlnh91ET7pzYZ2vD5AKVbBRfpVGVX29PlReyyq6Y9MaYVCSs/+WoCiv2JQTNbPVDgw==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_8_0;
    aspnetcore = aspnetcore_8_0;
  };

  sdk = sdk_8_0;

  sdk_8_0 = sdk_8_0_1xx;
}
