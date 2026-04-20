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
      pname = "Microsoft.AspNetCore.App.Ref";
      version = "10.0.5";
      hash = "sha512-Ktpg7S9q0hqEU61eFrv9MD9Tjlh1dzp2SgoDjr7JaiBOaNQOLtyYVAceV9ezAcJ4psLKsTKO81oX+Iuf4RhIEQ==";
    })
    (fetchNupkg {
      pname = "Microsoft.AspNetCore.App.Internal.Assets";
      version = "10.0.5";
      hash = "sha512-EVPO8CrM8wNIL1LpwgDzAzgAd/9GbyA6PiphaH678yedlzzMLZ5u5CINri9JAbJ3iW7QiTzOclPXhu0TWnQGlA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.DotNetAppHost";
      version = "10.0.5";
      hash = "sha512-LAqUC8iR3isE1E/FjWZ3ro1MyMXl3EnjkxlyNDr92fOxlcnnA4G5tdy67Vet3EuXIAtVNR2KPfCmykB7bEJgHA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NETCore.App.Ref";
      version = "10.0.5";
      hash = "sha512-vO3fy0Y/qnWjyZbWNWh+ccnwHhlwhm7Hz/HgN/YnkU03zWgqXHLzu2FSzvmkgk6RAsbzw8Nm+Co1FRA4dz+Fkg==";
    })
    (fetchNupkg {
      pname = "Microsoft.DotNet.ILCompiler";
      version = "10.0.5";
      hash = "sha512-Y6R0+8pMvCi7vq0R9RFtU6vj+gE6hFfAzXNMWKULFFHUlqbbVWhj3QBoQCOe5/4bQChk0QWg8k7i/pAxyj1WiA==";
    })
    (fetchNupkg {
      pname = "Microsoft.NET.ILLink.Tasks";
      version = "10.0.5";
      hash = "sha512-unnJquNAywt0vQGo/zeGot7T2h0vB2FPimnIe0F9grQj1RBDTOmStKHuTr/8TNd4F+tBXfWdBn8cp7+3Z1p8Fg==";
    })
  ];

  hostPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm";
        version = "10.0.5";
        hash = "sha512-D7Hz+xRec/A2VH9rwqrPxIM/YlHwbfDZV0Eikloh4eJl5LytP2EBCQjg+PWFmQnDoh4NxRFE5HKbtTaU9pqVkA==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-arm64";
        version = "10.0.5";
        hash = "sha512-pUikpkbJmTObQh5v7CrIGshp2kW+qYrxUVDML5pirTLPga3LI8PFp/IGaApvM2vO9nCj4QXwLCEm3WDi/aXNYg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.5";
        hash = "sha512-XpJ7rugEmUKjQMfXfLRcU4WrHFR6Oim1r8A/hASh/EZzr0/JqIzUMvi2xDr6d7Sz0Usdb6zAsJj1p3Yudf+XmA==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-x64";
        version = "10.0.5";
        hash = "sha512-NM7MFm5+nQ/sic0P2iGXgxwDj/bGZ2r3cjK+Ax2vvvQNHIJl5knw8y5r9lFSYpIwE4gA1FN66W5Yb8rQopHoyA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.5";
        hash = "sha512-Gi+ZdJq9xBsllyMv9TJAVtlMXeMpAWf3ArxJ49RJ2bpSW1lKc1nWEVQ3xI53MgGQTSi2D8fk/+mFP++jvBxD9w==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm";
        version = "10.0.5";
        hash = "sha512-cobJfKOo+3sLAO6DRwHUuwDVfbDYiXXtoR/lKyGbSfmWSLY1qfGzJTVBuNp/+Rtncn/OBJ6jQ1fAP9Sul1OH9Q==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-arm64";
        version = "10.0.5";
        hash = "sha512-qplAXaAnkLbVwaSI3zQB9YTfxrwv6xK4Ti3NPR0Hpywjqe1UhjHrefz4bJRVgh9QcNqLxdgH4ja6pMlvF2G10g==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.5";
        hash = "sha512-+4RIyAnPeoRDC1pxfS1fqlq5I8KRQgUc2hgLrNqbPmyO4M6QB3+e9u39fOZi/Hg/FHYx5TTVbB0GrhiCbMr+GQ==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.linux-musl-x64";
        version = "10.0.5";
        hash = "sha512-kNH0Wr161xmHhtwvu6hLn7ReMHHF/rr6orocFeAj7tXP1Mt3Hjpydl4ieTNXd+Q6QD2ufs14kQOcmXrWA6XCTg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.5";
        hash = "sha512-X8JiYyQFwRvpM63TI+szjk/2EVjkdn3QaxlDld7WrTB2EL/e6YPU5Vmot3Pjg4U/ORBi1bnygoAJIZWDBd1W/g==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-arm64";
        version = "10.0.5";
        hash = "sha512-GPptAxSiLpFiXblT0g+ourLNofK6j30a3KjIt74OiFklg9Tr5M2MKhV8KfzJ7kqeG8jgviYuHy+2yZ1+8QchGA==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.5";
        hash = "sha512-BflTzFpRaQF4mUd+dqgYfJvLn30XFLUofFnUYE485BePeXXu6rR/tOS3cVGgM3A32wqabsasYPrRfykQWs78ow==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.osx-x64";
        version = "10.0.5";
        hash = "sha512-zTRKBdj7hhJJJyXrlkcMiE+5rF/0JkiADnxVP2MRLyUvj4d0COAIsczwQgO3RxyYtsAgOiwwLscOWmb8A5pvvw==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.5";
        hash = "sha512-ZajiQZT7q2tQtOM18Lk8SWVoCcYLKg0YXDybHpIast0mqM4DXXvNXDeTOERufdioEoxy5s6STiOy7BPN7XnX6A==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-arm64";
        version = "10.0.5";
        hash = "sha512-mkjk4oeHj7mutqsszAWhxtFRwwjXFr1uI5JopdN31Y1v/rxFwfwzjftsnlEwNcMtxWftooVZK9+uBQ66iWE7Kw==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.DotNet.ILCompiler";
        version = "10.0.5";
        hash = "sha512-1bwi83hLpxKRElgr80UES+FV8uhIVX0T14hOSukAy6cgjxPVmkPvllcL2wcVL862IZ8mNvMubFMyIHI9X5tzKg==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x64";
        version = "10.0.5";
        hash = "sha512-AEDznHbzYo0x/j4NJmGN2+9iaVC4G+f/O7MZWJfgS1ghSlQ1nE78/9n/CaKRaLV0kJszOrHSVtVT+WpXygQBJw==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.DotNet.ILCompiler";
        version = "10.0.5";
        hash = "sha512-LVHy/0yiKtncb1QOk3ixTfpT7HyLqX0ahpybFSbr/E7D8jJOijQ3eFNHpyzO9IQ6yKpA1/f1maFy7xg9hMPxJQ==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Crossgen2.win-x86";
        version = "10.0.5";
        hash = "sha512-rsn1PvaakbpQfUOtyLodRcJuUyyn1I6ubGmt2Lfn6yVdLi761gEUqy+uPbyqw7UUBOVZHn4RPhspAXjIufixlQ==";
      })
    ];
  };

  targetPackages = {
    linux-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm";
        version = "10.0.5";
        hash = "sha512-+ilMva1bCAUMrOpPRiNfzSewq/Tp1JkrdioTJDxqpzsfBuOizDynqr0tBbckZnWiygo/tKjZWP8uoZNAscroZQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm";
        version = "10.0.5";
        hash = "sha512-ov3HneAvNdMPK9ALqRKEu13VADbbZ6D+jdRHqkx2pGAu6RvueNGLLbiufNTlTSLkXsZMI6XlU26aqycPG2zXdw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm";
        version = "10.0.5";
        hash = "sha512-JkHJiR7vL6mUtdIZz2YXIQtWqabjdgHaFxyt5jQWOJHCvc3RFAsOVSMMsAC8l+npjkjipTy1JDidbiygJtFGYw==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.5";
        hash = "sha512-qRze/kRX3MyRvmudB+SkxSdisBYtYCI/0s6uCq15j8MC5ls1slhDOQohBhpGqokJvO9p1/BkRyogAejmpveAmw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm";
        version = "10.0.5";
        hash = "sha512-GqlBlcnxxNX14NUTl13Hc/AewEadOuaWRpmQURs3zfvWjqMXkE1yDOxA/1j0KnFfJEjFXqYiAn8Q52gIYq1Wag==";
      })
    ];
    linux-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-arm64";
        version = "10.0.5";
        hash = "sha512-Kp+MsuKVXftYrRfCCSG1iX0Bx9PXtE6dkKof5WwgW4OKwEmQrZR1u/shk0pXlTt/j18sALS2HaZd0sHuHjVfXQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-arm64";
        version = "10.0.5";
        hash = "sha512-qt1Ap/tRTi6CavFtXJmBnzHpIBv+MXi8x2SZuNdolC5f9PJ91Knd3cRMl0doebNFo3USyWeSEMuox8opiVtdSQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-arm64";
        version = "10.0.5";
        hash = "sha512-7/upjkbj/5xKViNzlVkYPq0hIwCnjApGmxRCLWdW3HBXdwVUrVsvNtvXJW1L58HlIK9/AaErmZMrjjhfbZMUlA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.5";
        hash = "sha512-ucjmiECPTHBzvBe6H2fmsY6Ensjj7Ke5NUlOxFebQWhkdwS60zPOcMnSrns7qSJffL6jp9X0FOHWYUeImBc9dQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-arm64";
        version = "10.0.5";
        hash = "sha512-Z5+MK4jKA1mNwXAvtI0UTg67vop5LoHRtNgKtQLZkjk+ge+F36ybFQOOhcwBu2Yso5b0rn9V9H5DI0n8osNp3Q==";
      })
    ];
    linux-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-x64";
        version = "10.0.5";
        hash = "sha512-S/cZ4FGOWCCdkeV7itqKS5j7kui8GDnJW16yAWCT6QRRkbXF0yP7NE18hdnEydZaQT8NjECxRjp3mkwl/xkawQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-x64";
        version = "10.0.5";
        hash = "sha512-zL01730sNpJABOrMaIYjZvX1dYGB7FnIHHbFBuxUoRxxCKCxO/g+Xc3OHq5omR0R1Tj9VFrYZckPxSAh7tM3JA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-x64";
        version = "10.0.5";
        hash = "sha512-geyVni1xsr4NPqWB1ygit+ewOhJv3cHoh2PKT1dP+6AlBkeALZZnAhyrSuG0CHgIE8+mpFSv/CxQoWPWqFDZ/Q==";
      })
      (fetchNupkg {
        pname = "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.5";
        hash = "sha512-7GDrN+V3+go78AbI8EGZRbI4d1/446XUDrPs1fo8bXOUKmW3MhpVty5Yur/rShI+g0AaGtsOsETawLRKfrUxmA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-x64";
        version = "10.0.5";
        hash = "sha512-767sIOnHoYvcik6wLCvJg/aemlmHSqDQRaCghd36Go9QYJMuXcYtdGEk6m4mRVM3pEirS5/kVqZWtWhDdL5RpA==";
      })
    ];
    linux-musl-arm = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm";
        version = "10.0.5";
        hash = "sha512-DkRALJnKSi/+0zTBkQfLVZP8FR7Hb33CwS+upyYxq/Dpdi2oBjnr0pbJLdINR83j530P47VgUKwKr+l74ED51A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm";
        version = "10.0.5";
        hash = "sha512-SonDz+TLIIBe6rVjdzfKR7SyqvOn84ZAwrSLDWX2miRSwMN3iIYAHL1nkKii5aJhqUM0xbl69zRxEp0cbqkPbw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm";
        version = "10.0.5";
        hash = "sha512-g0ETxPNUff6SxCXrjUlzj9zy2nPpmgzbkEwayQngZTGR/zpgL5jLI1Q6e/GGGMCrpFc+SWIO1hxpqui1H4TARA==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.5";
        hash = "sha512-I4riXKiTE1O7a/H4aCTmIFRE4LlmMLwzyAo8HwbZUdqYNtFhqm7ByTJ3nHi8BTG5CPaE6BNJ27/MPNqN+sJ30w==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm";
        version = "10.0.5";
        hash = "sha512-yXSmkwzv6MdUniaBk7+lj/oV0Q5CoGiX6HF4ZxlUxaCTcLkg7XI+kRfBjD9ZYZHv8qChc/nkU9zJaZkpbQuOdw==";
      })
    ];
    linux-musl-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64";
        version = "10.0.5";
        hash = "sha512-IZTJ4sSam7VntRBhvpCjJoCDnb6F/uLy2wpdOTyrenwYxfdBYQPIPLJeAemH9wYuIAv1/ljd9N9HR3K/l8hT5Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-arm64";
        version = "10.0.5";
        hash = "sha512-8JZThCg9zOAu9PEJ/ETfAmGqL2sY88KNBp3MTZrjfQhYHGN+uTnqfUA7TpJtiTYFSrmY3kYJ5KBzv0jj/cNBHg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-arm64";
        version = "10.0.5";
        hash = "sha512-YLR/sCAc99a+zAWZEvP5NzdOg48vifHRdEx8PKIx9AG7upx7NUnp7Wi2HAfC9jzAMziP4Nsmk3qdAPKh3l2gyg==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.5";
        hash = "sha512-f0/gO5PzVXMrqeRATua6zobitnZ+iUE+JxYSw3P0BDgDFPt3+uWI/eULbLjTosr3nJdLF1Td9sNGYxpi54ivpA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-arm64";
        version = "10.0.5";
        hash = "sha512-3gLTjeteK89N5/onUYJm1KPt+xoTf37ZTJwJ+G9dv709v1zLDpZEUtG+puLOIZzCFpzqnBj+2+JDdYrX0skmkw==";
      })
    ];
    linux-musl-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.linux-musl-x64";
        version = "10.0.5";
        hash = "sha512-ao2tW5jlik4441BgZSpspSbcJneWxQhu/3eGL91EjY7JsQsOT5ga59ULSBWo9X6VuqeHQN8dVMkvNbRzMha7cw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.linux-musl-x64";
        version = "10.0.5";
        hash = "sha512-+McjW48YCQx/uNHsyMjowcG0cFg/fv+P9wAQ3ra3cwjbkkSbuAQcfEDiF98mwfPOdcF5xFVSiUJKErnOX4YScw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.linux-musl-x64";
        version = "10.0.5";
        hash = "sha512-dvIY+3OjpqPeYN7nUzmCE0AcOAuzAFzH6/XnRq6MeqEHjFaTAU0uapdxn+qDOvAvspF37mdIUVuNFrlTGkCC6A==";
      })
      (fetchNupkg {
        pname = "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.5";
        hash = "sha512-RoiIBfpNaQReuCqRqzJ0pe06udmDpf5mgKRDdXilw19ZXhz1rs6apVKbaMQAPUDwdxQoiuxhFIA1EQSZCfImsA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.linux-musl-x64";
        version = "10.0.5";
        hash = "sha512-z/tKLcDLBPdTiyq9LiHb2OcvxhizFcN2lOdkmMdOP1Eh1BQ06ws+8yzdtQGSzDzmvo1uGES+7Dor4qDtMcUYiw==";
      })
    ];
    osx-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-arm64";
        version = "10.0.5";
        hash = "sha512-E49zQ382W6Tdx+kTqxwS/6AaWXhOn1ToqArv6Q52HQLEPzouYvXKZWgw5cPIUnqk2lDO1xLnWJ3WgLt5t3XxVQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-arm64";
        version = "10.0.5";
        hash = "sha512-tF2X+/u+NZTLFMNA3yhZhbUr/w5dc6J/6ARfV/MDcaiNWawD1XmK/lpNlOPaLJYdSPpzL0cELZ+MdD/bGiL72A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-arm64";
        version = "10.0.5";
        hash = "sha512-gSNu28XZcmjXfcbd1k1/05Yt1705LtruRRvU8ISXYaSHDhBkE2b1ylBZEV26OfnJFdxfF30lGXFoVzk1UqvYpg==";
      })
      (fetchNupkg {
        pname = "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.5";
        hash = "sha512-6mVo20DumP+FsdR53lOJvDBFYc5707rwqU925HHEsxYhsNk8v/BfRRGynmCINpoCElBZ7YinP+nhCGdWSf31Sg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-arm64";
        version = "10.0.5";
        hash = "sha512-kN11Hky8RX71JccTcYPDXa9FHW0P2MPpZYyeWb0xZcYQX8l+9g6VdOZ1s40g1izuYUWR1LYCcaZkClix8QvPcg==";
      })
    ];
    osx-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.osx-x64";
        version = "10.0.5";
        hash = "sha512-vL/Xgnw66cgdg2cwwttTEJ5BaHokLhjjW/q/eWQfkGwNF8DchzR4PFoMKd+o3Zk+6I5AZneWn1mGYLpo39JS+Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.osx-x64";
        version = "10.0.5";
        hash = "sha512-aKH4tQCrzWnVntcprnrsQVLpLMrn2gJXSLqRT2AH9+9kCq7qdelzev1JY+O3Fb+/dp+/v9mVOXde9GHu8G2uaw==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.osx-x64";
        version = "10.0.5";
        hash = "sha512-Pty0O+hUt8GO3kB3XY3lGic5EKgbMgzY/n8XvkBsaVspJ9VeTvlvbhffZ81vMDfARdeQ4uYXzd5a14NSEfdNhQ==";
      })
      (fetchNupkg {
        pname = "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.5";
        hash = "sha512-U/Xph2FJHj79dHtyOWI4+pp2ZGgD4v9Ky+hOQyRmgN42x+uYUe3ylyW5hVQoVH83SjtrZvW0OHJ7TU9dcAZRfA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.osx-x64";
        version = "10.0.5";
        hash = "sha512-+j/ZvkuvYbsipm16qIMyyEoYU9bN1ocGk0Bb9VMFA2nm+u7i6uNCZHgbKirpDeXiw+jLwTagv0542P0++ZqQUw==";
      })
    ];
    win-arm64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-arm64";
        version = "10.0.5";
        hash = "sha512-XBGMqFcb278bleC2+uieyUHFYAYdCwDlqPKa2JpiLrSdbFwbTD0jd/bACFCfeJj23gPWS0hUrFP9U6sexov1hA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-arm64";
        version = "10.0.5";
        hash = "sha512-R6wUWrRt8Q01feMFx+rooVC3QgJzoPrqnHkpFOVyFP8vbtJJc0QFADpyGolcTQHdaS1qocx+tOE2O85rxSzfBg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-arm64";
        version = "10.0.5";
        hash = "sha512-V9BNBzKC9tb37jjsdkPE3XrLa+9hVIzSy1QQqD79/ZXNbC481DKzJzbSEWqZtlH/jn+oxLTVioo1cyNcMtE5lg==";
      })
      (fetchNupkg {
        pname = "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.5";
        hash = "sha512-CMdJ1KpI63ld8rfiiYqB7JPEi1RZ6qRqv0xip5OsieJ1IQGKbje5mdxrVqqLiIveUGsdf99Y0rJMEv7vQwFLDA==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-arm64";
        version = "10.0.5";
        hash = "sha512-SF1sLHKC/+acZAZzLf6KEHnc35UToczWBIUTJTkG6YgAIxrtkDZ87UuhuJ88nG3SXzUu10oM3iJ2n5BcBAB+8w==";
      })
    ];
    win-x64 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x64";
        version = "10.0.5";
        hash = "sha512-IHCUjslASrwPeYCuVEqNtLfuhIEgvPH0XhfigHyHsmUeV7o6UBKE4XmINjufE2tsgXUnlRG4yHZVgahqFVYQ0Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x64";
        version = "10.0.5";
        hash = "sha512-ts+lw10c/3rqMgwwIEq7KKJ1elP4GL4I6h/vZ6L/gdBZTneCqUU/1yiDpKmGWWPc3sRgM/jh+juYibH3ZxrwOg==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x64";
        version = "10.0.5";
        hash = "sha512-GZ8vwTCPtxnQifh60odRfe0aq9+6RkTYkqXa0JxVI4t2HxPDO3JDkwLlUKZdiFgfDRQ4rkux01Pui3rO1kmpLA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x64.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.5";
        hash = "sha512-yAa6A28bU0SgTVjKvEHI254vgaRbQOX5zwyqelczF4Up95wnUdbo+dlgVKcDqaQtnGdV3A+FI2lCANj5IPyP8A==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x64";
        version = "10.0.5";
        hash = "sha512-KNQZFfnPusZJz9KKGQ0MYujNI3OvPr4Ce9l73T3jCXbh7y80y/JFimg+0Whrz/mHBLWOpLt7/1cVJw5psV8rNg==";
      })
    ];
    win-x86 = [
      (fetchNupkg {
        pname = "Microsoft.AspNetCore.App.Runtime.win-x86";
        version = "10.0.5";
        hash = "sha512-vYxGmc8gORpENpwj3x5KX799nmztgPAeoCUJIjgffzh//2cSeNxnKSBlDF/UHEMWIxzS+KvIySa3xe/0UWT6tQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Host.win-x86";
        version = "10.0.5";
        hash = "sha512-56DjoIPiUrCz+KNihIcywDJooPmHzFYpEPgWaZVb6p30OOs1KFNnoQhD9Yy4BqeMR0YrIuf1otKKpb5oeJ20nQ==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.win-x86";
        version = "10.0.5";
        hash = "sha512-keZXRiTa8DMzEyk5r72fy+KcARATMLx9SjdG8tPt1spm5q53E51r70JgTYUWmy/EArb6agEAWcriBdGH4nhcyA==";
      })
      (fetchNupkg {
        pname = "runtime.win-x86.Microsoft.NETCore.DotNetAppHost";
        version = "10.0.5";
        hash = "sha512-mq3Dk48HNnAlEfVTFpne0lP94hgJrQCYTSxOwWolaS+yc6oMXzCmJ00tBaMn4gH+I5AwBrRhCJu90tRGFw8L8Q==";
      })
      (fetchNupkg {
        pname = "Microsoft.NETCore.App.Runtime.NativeAOT.win-x86";
        version = "10.0.5";
        hash = "sha512-uYEXkEpI1YGxnwPAvefr8htm+bsGOZhA+1Lqgr6jecFcsV79tPHNa/RGZtWBi3Jca272oojjqnXIc3ai4QQKRg==";
      })
    ];
  };

in
rec {
  release_10_0 = "10.0.5";

  aspnetcore_10_0 = buildAspNetCore {
    version = "10.0.5";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.5/aspnetcore-runtime-10.0.5-linux-arm.tar.gz";
        hash = "sha512-GuziriIhK5fpgTan7noU2WkAGceJ8U4LgReFY5B9FSHwlxvITa4we4KWJv9n16tm3+sSAP+EiJnXykBQ/IRUHA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.5/aspnetcore-runtime-10.0.5-linux-arm64.tar.gz";
        hash = "sha512-bKs7gZELo+bhGFlaRZSDMfXRUGtCrwlC956j22Yj6CBVehdXlzvsua/T1vjq2emmQWZ4YPKn+71Zi8r6OPRznA==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.5/aspnetcore-runtime-10.0.5-linux-x64.tar.gz";
        hash = "sha512-cQjs3ajiYH+oDitF8SCdevUwHVNDi2XSJpYFuEFa69SdsjRV2NzXfY/czJBMkgK0g0+couAOJ6UB0gBhdNdsxA==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.5/aspnetcore-runtime-10.0.5-linux-musl-arm.tar.gz";
        hash = "sha512-8QYwDJeXiTDL8weEVdh1kU1JtRgRkPCUZWqmbpJBUhUFiJH8JVH+fW7gMaptsLnWhOLw4lHaFf4sg2EUb+98oQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.5/aspnetcore-runtime-10.0.5-linux-musl-arm64.tar.gz";
        hash = "sha512-mHRGpwP/9xNtrY42UX6BAnkuPlerK5G2mkPoPIRV/D6wZy+3ElLuBZ6OlPlstV4ZcGuJgOPfKgbKzVtwUwV35g==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.5/aspnetcore-runtime-10.0.5-linux-musl-x64.tar.gz";
        hash = "sha512-enudhD7jCKrSkqfaGJAfP8oCaV0XoVscuKeFfOEQLrcT+g8VBdTih9sORz0zFkzMas+SdcIx0GsjpUtpvv3T1w==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.5/aspnetcore-runtime-10.0.5-osx-arm64.tar.gz";
        hash = "sha512-uGWDyRjReUEAiAhE2hAoQwnQtlcGC5cGixJY319lsQWq42zF+H08z+JAhzro8EUMb/x3MI2OXP0eTLkYelKxDw==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/aspnetcore/Runtime/10.0.5/aspnetcore-runtime-10.0.5-osx-x64.tar.gz";
        hash = "sha512-Grw3e0NaX5p0fELMexfNLoxgR02XH3GelS8OYPWv+iVp5EZkhiEhODjWhQbfgOFbKo8zI4IOfyLyVRvPEJx8Ow==";
      };
    };
  };

  runtime_10_0 = buildNetRuntime {
    version = "10.0.5";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.5/dotnet-runtime-10.0.5-linux-arm.tar.gz";
        hash = "sha512-Jj8OoRHgcpPzA9RnPuNMGR5Ed0CmBLZ8WzXbx1smC7R7w3SX5IuELL39wpppAMKXZbpna0EHZKwrokGciT+OJg==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.5/dotnet-runtime-10.0.5-linux-arm64.tar.gz";
        hash = "sha512-4jd8PCWQaNhgO6WgF5DexHbd42ELLSXlco733GbqR1BXRuhtMk+lK/yfFW7R4XAziJ95RLdSr66YOova7F6Qeg==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.5/dotnet-runtime-10.0.5-linux-x64.tar.gz";
        hash = "sha512-knwiavQKvaWYax05TtlL8ACKJ5aN5A7HAr4vo+2HGsarbSa5aLjMrT9IkSaMz4QLvUQBxqeli6rDyHtf6NyVkQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.5/dotnet-runtime-10.0.5-linux-musl-arm.tar.gz";
        hash = "sha512-zHRDvb4j4PD++ndXNkOpzI9rjnGLexaz2KIph/jhF8FmeMCkkVqj+18Iz5DJE6mYLKQ3CqDLYHRAidizC5Fipg==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.5/dotnet-runtime-10.0.5-linux-musl-arm64.tar.gz";
        hash = "sha512-77by38lmtLmAFobWKvlEJcZ9jzdVfMlCgSIbESrLtgZ9eEENioHrU3qkhPGYta/yjl0KYrfoJqDlU0N6KJC0mg==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.5/dotnet-runtime-10.0.5-linux-musl-x64.tar.gz";
        hash = "sha512-v4rFy1JPAwwtOCxhi45R0SWlySjFa1A1H8Lau8ijfTVSvXvCZeLay1W/FSiHaVH1K5CSFlKEu9IX+jyJqqHjfQ==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.5/dotnet-runtime-10.0.5-osx-arm64.tar.gz";
        hash = "sha512-saRJmrOWdccRiWFctymL5sgJaLbxEehabDflHdc/SYX2gkJcjKX5Zyz5vU0gjZZUxQKb2QH9C/wHKceNRTAQUQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Runtime/10.0.5/dotnet-runtime-10.0.5-osx-x64.tar.gz";
        hash = "sha512-hAyjxQFVv7pSZYYlEybwAU01Ew32BI3eIq0Z5ckUq6EBsQUXt1bO5xMC8bIH/iKxTmdaa+eLuJeManTHjTpg4A==";
      };
    };
  };

  sdk_10_0_1xx = buildNetSdk {
    version = "10.0.105";
    srcs = {
      linux-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.105/dotnet-sdk-10.0.105-linux-arm.tar.gz";
        hash = "sha512-BYl4cX5Opk3MeYSeLngTjUOoowyeq+mxKLxSUf+maPHAFD5tBmOK9zQ/ukm7k8weLgVauJsMJfz20MowNo0oXA==";
      };
      linux-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.105/dotnet-sdk-10.0.105-linux-arm64.tar.gz";
        hash = "sha512-MF3H5/uZ/NiDDTkSKBf/W04EiMz2Mcuc3H16jsHgQFwc93IaWgERVKWpbPzDl1xgzToEjV0OgADbVAWXlP+olw==";
      };
      linux-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.105/dotnet-sdk-10.0.105-linux-x64.tar.gz";
        hash = "sha512-Kw7RMQbkyFnMueOl8aRQ6EYF69ib2ErDRTswgQ7PpitpV7qqLtBBzC6TL1EhE+FuOuIA/lxLSL5mdndHoG9OQQ==";
      };
      linux-musl-arm = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.105/dotnet-sdk-10.0.105-linux-musl-arm.tar.gz";
        hash = "sha512-6D2zGInXEQdr4eOol/CAA9T3bE5RyGl1rAFA21jN/34mplF078z+pyc2hXE20CvDOqF1wP4K8pZ7SEUXScetUQ==";
      };
      linux-musl-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.105/dotnet-sdk-10.0.105-linux-musl-arm64.tar.gz";
        hash = "sha512-EzORZO6Xm5QM66MKrIAzbxVAdNYIIyJBQNAUXYbLvsF/MMtIFQ3fPSVClKJ0ohOivTlLwZdPo1dmHSCaXISdSQ==";
      };
      linux-musl-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.105/dotnet-sdk-10.0.105-linux-musl-x64.tar.gz";
        hash = "sha512-JUuwDV5oqtO2+4WEcwG8AIq2iex49gE5fBx2JApm6GZI66oq/32za+NVwl78C7LIHCK1hm903zcQDDlYm8XIng==";
      };
      osx-arm64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.105/dotnet-sdk-10.0.105-osx-arm64.tar.gz";
        hash = "sha512-kFi8F6r3bQLmamLhJuraDDQwdeQAcx63QVUvF7nMOjPxhUEV2W6TfU45GOnIBdtb8q0wm8RciSIoxOdTSDktYQ==";
      };
      osx-x64 = {
        url = "https://builds.dotnet.microsoft.com/dotnet/Sdk/10.0.105/dotnet-sdk-10.0.105-osx-x64.tar.gz";
        hash = "sha512-b9HYoiXoPfpgO0uniMR37zQFLW+7KcH6FXRn+xmKAHEHgnqWGk2u4S8uXSctGFxUpfJeYe/hkEPG/xVD9BF1xg==";
      };
    };
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_10_0;
    aspnetcore = aspnetcore_10_0;
  };

  sdk = sdk_10_0;

  sdk_10_0 = sdk_10_0_1xx;
}
